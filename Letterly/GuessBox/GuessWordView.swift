//
//  GuessWordView.swift
//  Letterly
//
//  Created by Konrad on 20/02/2024.
//

import SwiftUI

struct GuessWordView: View {
    
    @EnvironmentObject var gameModel: GameViewVM
    
    var attemptNumber: Int
    let boxScale: CGFloat = 0.8
    
    init(id: Int) {
        self.attemptNumber = id
    }
    
    var body: some View {
        GeometryReader(content: { g in
            HStack(alignment: .top, spacing: 0) {
                ForEach((0...4), id: \.self) { i in
                    LetterBox(letter: $gameModel.wordGuessAttempts[self.attemptNumber][i].letter,
                              state:$gameModel.wordGuessAttempts[self.attemptNumber][i].state)
                        .frame(width: (g.size.width*boxScale)/CGFloat(5), height: (g.size.width*boxScale)/CGFloat(5))
                        .padding([.leading], (g.size.width*(1-boxScale))/CGFloat(6))
                }
            }
        })
    }
}

#Preview {
    GuessWordView(id: 0)
}
