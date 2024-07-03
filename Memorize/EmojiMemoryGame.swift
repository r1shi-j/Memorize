//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Rishi Jansari on 30/06/2024.
// MARK: ViewModel

import SwiftUI

class EmojiMemoryGame: ObservableObject {
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
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func newGame() {
        model.newGame()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
