//
//  ContentView.swift
//  Memorize
//
//  Created by Rishi Jansari on 27/06/2024.
//

import SwiftUI

let animalEmojis: [String] = ["🐶", "🐱", "🐭", "🐰", "🐼", "🦊", "🐯", "🦁", "🐮", "🐷"/*, "🐵", "🐸", "🐔", "🦄", "🦉"*/]
let fruitEmojis: [String] = ["🍏", "🍐", "🍊", "🍋", "🍓", "🍇", "🍉", "🍌", "🫐"/*, "🍍", "🥥", "🍒", "🥭", "🥝"*/]
let vehicleEmojis: [String] = ["🚗", "🚕", "🚌", "🏎️", "🚓", "🚑", "🚒", "🚐"/*, "🚚", "🚜", "🚅", "🚂", "🚃", "🚁", "🛩️", "🛥️"*/]

struct ContentView: View {
    @State var themeEmojis: [String] = (animalEmojis + animalEmojis).shuffled()
    @State var themeColor: Color = .brown
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            ScrollView {
                cards
            }
            themePicker
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 8) {
            ForEach(themeEmojis.indices, id: \.self) { index in
                CardView(content: themeEmojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(themeColor)
    }
    
    var themePicker: some View {
        HStack(alignment: .lastTextBaseline, spacing: 45) {
            someTheme(theme: "Animals", symbol: "dog")
            someTheme(theme: "Fruits", symbol: "carrot")
            someTheme(theme: "Vehicles", symbol: "car")
        }
        .imageScale(.large)
    }
    
    func someTheme(theme: String, symbol: String) -> some View {
        Button(action: {
            switch theme {
            case "Animals":
                themeEmojis = (animalEmojis + animalEmojis).shuffled()
                themeColor = .brown
            case "Fruits":
                themeEmojis = (fruitEmojis + fruitEmojis).shuffled()
                themeColor = .pink
            case "Vehicles":
                themeEmojis = (vehicleEmojis + vehicleEmojis).shuffled()
                themeColor = .blue
            default:
                themeEmojis = (animalEmojis + animalEmojis).shuffled()
            }
        }, label: {
            VStack {
                Image(systemName: symbol)
                Text(theme)
                    .font(.caption)
            }
            .tint(theme == "Animals" ? .brown : (theme == "Fruits" ? .pink : .blue))
        })
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content)
                    .font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
