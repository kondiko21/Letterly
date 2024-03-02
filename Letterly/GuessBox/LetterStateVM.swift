//
//  GuessViewState.swift
//  Letterly
//
//  Created by Konrad on 23/02/2024.
//

import Foundation

struct LetterStateVM: Hashable {
    
    var letter : String = ""
    var state: BoxState = .neutral
    
    init(_ letter: String) {
        self.letter = letter
    }
    
    init() {
        self.letter = ""
    }
    
}
