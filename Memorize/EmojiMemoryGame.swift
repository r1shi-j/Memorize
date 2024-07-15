//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rishi Jansari on 30/06/2024.
// MARK: ViewModel

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["🍏", "🍐", "🍊", "🍋", "🍓", "🍇", "🍉", "🍌", "🫐", "🍍", "🥥", "🍒", "🥭", "🥝", "🍑"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 15) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "!?"
            }
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    var color: Color {
        .pink
    }
    
    var score: Int {
        model.score
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func newGame() {
        model.newGame()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
}
