//
//  LetterBox.swift
//  Letterly
//
//  Created by Konrad on 18/02/2024.
//

import SwiftUI

struct LetterBox: View {
    
    @State var letter: String = "K"
    @State var state: BoxState = .neutral
    
    var body: some View {
        ColorCutView(color: state.color)
            .foregroundStyle(state.color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                Text(letter)
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.05)
            }
            .shadow(color: .gray, radius: 2)
            .animation(Animation.easeInOut, value: state.color)
    }
}

#Preview {
    LetterBox()
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
            return Color(.green)
        }
        
    }
    
}
