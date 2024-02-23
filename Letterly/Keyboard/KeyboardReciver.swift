//
//  KeyboardReciever.swift
//  Letterly
//
//  Created by Konrad on 22/02/2024.
//

import Foundation

class KeyboardReciever: ObservableObject {
    @Published var letter: String
    
    init(letter: String) {
        self.letter = ""
    }
}
