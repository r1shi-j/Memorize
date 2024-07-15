//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Rishi Jansari on 30/06/2024.
// MARK: Model

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<max(2,numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
        
//        shuffle() // shuffle on start
    }
    
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only } // returns the only card that is face up
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2 + cards[chosenIndex].bonus + cards[potentialMatchIndex].bonus
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        if cards[potentialMatchIndex].hasBeenSeen {
                            score -= 1
                        }
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
        /*
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched { // if chosen card not face up and not matched
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard { // if 1 card already face up
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content { // if chosen card and already face up card contain same content (emoji)
                        cards[chosenIndex].isMatched = true // matches both cards which set opacity to 0 so hidden
                        cards[potentialMatchIndex].isMatched = true
                        score += 2 // plus 2 point for a match
                    }
                    if cards[chosenIndex].hasBeenSeen { // if card has been seen minus 1 point
                        score -= 1
                    }
                    if cards[potentialMatchIndex].hasBeenSeen {
                        score -= 1
                    }
                } else { // if no cards face up
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex // sets face up card index to the chosen card
                }
                cards[chosenIndex].isFaceUp = true // chosen card is now face up
                
            } else if cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched { // if card face up and not matched
                if let potentialIndex = indexOfTheOneAndOnlyFaceUpCard { // if 1 card already face up
                    if chosenIndex == potentialIndex { //if selected card is the only face up card
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1 // minus 1 point only if has been seen
                        }
                        cards[chosenIndex].isFaceUp = false //turns the face up card back down
                    }
                } else { // 0 or 2 cards face up
                    cards[chosenIndex].isFaceUp = false // turns selected card over
                    cards[indexOfTheOneAndOnlyFaceUpCard!].isFaceUp = false // turns other face up card over

                } // When only 1 card up and is tapped again it will turn back over
            } // When 2 cards and either tapped they both turn back over
        }
         */
    }
    
    // MARK: Point Scoring
    // For every match +2 point
    // If card has been seen before and is show again, -1 point regardless whether a match
    // eg if 1 card been seen, 1 not seen and they are a match, +2 -1 so +1 points
    // If 2 cards been seen and a match, +2 -2 so ±0 points
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func newGame() {
        cards.indices.forEach { cards[$0].isFaceUp = false } // sets all cards to face down and unmatched and not been seen
        cards.indices.forEach { cards[$0].isMatched = false }
        cards.indices.forEach { cards[$0].hasBeenSeen = false }
        shuffle()
//        score = 0
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        var hasBeenSeen = false
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        let content: CardContent
        
        var id: String
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up":"down") \(isMatched ? "matched":"")"
        }
        
        // call this when the card transitions to face up state
                private mutating func startUsingBonusTime() {
                    if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                        lastFaceUpDate = Date()
                    }
                }
                
                // call this when the card goes back face down or gets matched
                private mutating func stopUsingBonusTime() {
                    pastFaceUpTime = faceUpTime
                    lastFaceUpDate = nil
                }
                
                // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
                // this gets smaller and smaller the longer the card remains face up without being matched
                var bonus: Int {
                    Int(bonusTimeLimit * bonusPercentRemaining)
                }
                
                // percentage of the bonus time remaining
                var bonusPercentRemaining: Double {
                    bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
                }
                
                // how long this card has ever been face up and unmatched during its lifetime
                // basically, pastFaceUpTime + time since lastFaceUpDate
                var faceUpTime: TimeInterval {
                    if let lastFaceUpDate {
                        return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
                    } else {
                        return pastFaceUpTime
                    }
                }
                
                // can be zero which would mean "no bonus available" for matching this card quickly
                var bonusTimeLimit: TimeInterval = 6
                
                // the last time this card was turned face up
                var lastFaceUpDate: Date?
                
                // the accumulated time this card was face up in the past
                // (i.e. not including the current time it's been face up if it is currently so)
                var pastFaceUpTime: TimeInterval = 0
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
