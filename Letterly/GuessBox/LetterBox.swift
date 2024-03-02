//
//  LetterBox.swift
//  Letterly
//
//  Created by Konrad on 18/02/2024.
//

import SwiftUI

struct LetterBox: View {
    
    @Binding var letter: String
    @Binding var state: BoxState
    
    init(letter: Binding<String>, state: Binding<BoxState>) {
        self._letter = letter
        self._state = state
    }
    
    var body: some View {
        ColorCutView(color: state.color)
            .foregroundStyle(state.color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .gray, radius: 2)
            .overlay {
                Text(letter)
                    .font(.system(size: 100))
                    .foregroundStyle(.black)
                    .minimumScaleFactor(0.05)
            }
            .animation(Animation.easeInOut, value: state.color)
    }
}

enum BoxState {
    case neutral
    case invalid
    case partlyCorrect
    case correct
    
    var color: Color {
        switch self {
        case .neutral:
            return Color("letterbox.neutral")
        case .invalid:
            return Color(.red)
        case .partlyCorrect:
            return Color(.yellow)
        case .correct:
            return Color("letterbox.correct")
        }
        
    }
    
}
