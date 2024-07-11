//
//  CardView.swift
//  Memorize
//
//  Created by Rishi Jansari on 07/07/2024.
//

import SwiftUI

struct CardView: View {
    let card: MemoryGame<String>.Card
    typealias Card = MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        Pie(endAngle: .degrees(240))
            .opacity(Constants.Pie.opacity)
            .overlay(
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(Constants.Pie.inset)
            )
            .padding(Constants.inset)
            .cardify(isFaceUp: card.isFaceUp)
        .opacity(card.isMatched ? 0 : 1)
//        .opacity(card.isFaceUp || !card.isMatched ? 1: 0)
    }
    
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 8
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 2
            static let scaleFactor = smallest / largest
        }
        struct Pie {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 11
        }
    }
}

#Preview {
    CardView(CardView.Card(content: "n", id: "test"))
        .padding()
        .foregroundStyle(.green)
}
