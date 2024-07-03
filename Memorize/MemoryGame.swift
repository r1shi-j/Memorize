//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Rishi Jansari on 30/06/2024.
// MARK: Model

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<max(2,numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
        
        shuffle()
    }
    
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            } else if cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if chosenIndex == potentialIndex {
                        cards[chosenIndex].isFaceUp = false
                    }
                } else {
                    cards[chosenIndex].isFaceUp = false
                    cards[indexOfTheOneAndOnlyFaceUpCard!].isFaceUp = false
                }
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func newGame() {
        cards.indices.forEach { cards[$0].isFaceUp = false }
        cards.indices.forEach { cards[$0].isMatched = false }
        shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        
        var id: String
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up":"down") \(isMatched ? "matched":"")"
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
