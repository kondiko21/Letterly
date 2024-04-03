//
//  LetterlyApp.swift
//  Letterly
//
//  Created by Konrad on 18/02/2024.
//

import SwiftUI

@main
struct LetterlyApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.font, Font.custom("Rubik-VariableFont_wght", size: 14))
        }
    }
}
