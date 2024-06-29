//
//  ContentView.swift
//  Memorize
//
//  Created by Rishi Jansari on 27/06/2024.
//

import SwiftUI

enum Themes {
    case vehicle, animal, fruit
}

struct ContentView: View {
    let vehicleEmojis: [String] = ["🚗", "🚕", "🚌", "🏎️", "🚓", "🚑", "🚒", "🚐", "🚚", "🚜"/*, "🚅", "🚂", "🚃", "🚁", "🛩️", "🛥️"*/]
    let animalEmojis: [String] = ["🐶", "🐱", "🐭", "🐰", "🐼", "🦊", "🐯", "🦁", "🐮"/*, "🐷", "🐵", "🐸", "🐔", "🦄", "🦉"*/]
    let fruitEmojis: [String] = ["🍏", "🍐", "🍊", "🍋", "🍓", "🍇", "🍉", "🍌"/*, "🫐", "🍍", "🥥", "🍒", "🥭", "🥝"*/]
    
    @State var currentThemeEmojis: [String] = []
    @State var currentTheme: Themes = .vehicle
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            ScrollView {
                cards
            }
            Spacer()
            themePicker
        }
        .padding()
        .onAppear {
            currentThemeEmojis = themeEmojis(theme: currentTheme)
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 8) {
            ForEach(currentThemeEmojis.indices, id: \.self) { index in
                CardView(content: currentThemeEmojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(matchColors(theme: currentTheme))
    }
    
    var themePicker: some View {
        HStack(spacing: 45) {
            someTheme(name: "Vehicles", image: "car", theme: .vehicle)
            someTheme(name: "Animals", image: "dog", theme: .animal)
            someTheme(name: "Fruits", image: "carrot", theme: .fruit)
        }
        .imageScale(.large)
    }
    
    func someTheme(name: String, image: String, theme: Themes) -> some View {
        Button(action: {
            currentTheme = theme
            currentThemeEmojis = themeEmojis(theme: theme)
        }, label: {
            VStack {
                Image(systemName: image)
                Text(name)
                    .font(.caption)
            }
            .tint(matchColors(theme: theme))
        })
    }
    
    func matchTheme(theme: Themes) -> [String] {
        switch theme {
        case .animal:
            return animalEmojis
        case .fruit:
            return fruitEmojis
        case .vehicle:
            return vehicleEmojis
        }
    }
    
    func makePairs(list: [String]) -> [String] {
        return list + list
    }
    
    func randomizeList(list: [String]) -> [String] {
        return list.shuffled()
    }
    
    func themeEmojis(theme: Themes) -> [String] {
        var emojis = matchTheme(theme: theme)
        emojis = makePairs(list: emojis)
        emojis = randomizeList(list: emojis)
        return emojis
    }
    
    func matchColors(theme: Themes) -> Color {
        switch theme {
        case .animal:
            return .brown
        case .fruit:
            return .pink
        case .vehicle:
            return .blue
        }
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
