//
//  LetterBox.swift
//  Letterly
//
//  Created by Konrad on 18/02/2024.
//

import SwiftUI

struct LetterBox: View {
    
    @EnvironmentObject var gameModel: GameViewVM
    @Binding var letter: String
    @Binding var state: BoxState
    var attemptNumber: Int
    @State var isActive: Bool = false
    
    init(letter: Binding<String>, state: Binding<BoxState>, attemptNumber: Int) {
        self._letter = letter
        self._state = state
        self.attemptNumber = attemptNumber
    }
    
    var body: some View {
            ColorCutView(color: state.color)
                .foregroundStyle(state.color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .gray, radius: 2)
                .overlay {
                    ZStack {
                        if !isActive {
                            Color("letterbox.inactive").opacity(0.5)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Text(letter)
                            .font(.system(size: 100))
                            .foregroundStyle(.black)
                            .minimumScaleFactor(0.05)
                    }
                }
                .animation(Animation.easeInOut, value: state.color)
                .onChange(of: gameModel.round) { newValue in
                    withAnimation(.easeIn) {
                        if attemptNumber <= gameModel.round {
                            isActive = true
                        } else {
                            isActive = false
                        }
                    }
                }
                .onAppear {
                    if attemptNumber <= gameModel.round {
                        isActive = true
                    } else {
                        isActive = false
                    }
        }
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
