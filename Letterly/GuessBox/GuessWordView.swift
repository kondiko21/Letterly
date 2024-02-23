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
    var word: [String] {
        gameModel.wordGuessAttempts[self.attemptNumber]
    }
    let boxScale: CGFloat = 0.8
    
    init(id: Int) {
        self.attemptNumber = id
    }
    
    var body: some View {
        GeometryReader(content: { g in
            HStack(alignment: .top, spacing: 0) {
                ForEach((1...5), id: \.self) { i in
                    LetterBox(letter: "", state: .neutral)
                        .frame(width: (g.size.width*boxScale)/CGFloat(word.count), height: (g.size.width*boxScale)/CGFloat(word.count))
                        .padding([.leading], (g.size.width*(1-boxScale))/CGFloat(word.count+1))
                }
            }
        })
    }
}

#Preview {
    GuessWordView(id: 0)
}
