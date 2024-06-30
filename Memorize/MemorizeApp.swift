//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Rishi Jansari on 27/06/2024.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()

    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
