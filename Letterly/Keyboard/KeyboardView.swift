//
//  KeyboardView.swift
//  Letterly
//
//  Created by Konrad on 21/02/2024.
//

import SwiftUI

struct KeyboardView: View {
    
    @EnvironmentObject var viewModel: GameViewVM
    
    var body: some View {
        GeometryReader { g in
            VStack(alignment: .center, spacing:0) {
                HStack(spacing:0) {
                    ForEach($viewModel.keyboradRows[0], id: \.self) { button in
                        ButtonView(letter: button.letter.wrappedValue, state: button.state)
                            .frame(width: g.size.width*0.9/10)
                            .padding([.trailing,.leading], g.size.width*0.1/22)
                    }
                }
                HStack(spacing:0) {
                    ForEach($viewModel.keyboradRows[1], id: \.self) { button in
                        ButtonView(letter: button.letter.wrappedValue, state: button.state)
                            .frame(width: g.size.width*0.9/10)
                            .padding([.trailing,.leading], g.size.width*0.1/22)
                    }
                }
                HStack(spacing:0) {
                    ButtonView(icon: Image(systemName: "checkmark"), sign: "confirm")
                        .frame(width: g.size.width*0.9/10*1.5, height: g.size.width*0.9/10*1.5)
                        .padding([.trailing,.leading], g.size.width*0.1/22)
                    ForEach($viewModel.keyboradRows[2], id: \.self) { button in
                        ButtonView(letter: button.letter.wrappedValue, state: button.state)
                            .frame(width: g.size.width*0.9/10)
                            .padding([.trailing,.leading], g.size.width*0.1/22)
                    }
                    ButtonView(icon: Image(systemName: "delete.left"), sign: "delete")
                        .frame(width: g.size.width*0.9/10*1.5, height: g.size.width*0.9/10*1.5)
                        .padding([.trailing,.leading], g.size.width*0.1/22)
                }
                HStack(spacing:0) {
                    ForEach($viewModel.keyboradRows[3], id: \.self) { button in
                        ButtonView(letter: button.letter.wrappedValue, state: button.state)
                            .frame(width: g.size.width*0.9/10)
                            .padding([.trailing,.leading], g.size.width*0.1/22)                    }
                }
                
            }
            .padding([.leading, .trailing], g.size.width*0.1/22)
        }
    }
}

struct ButtonView: View {
    
    @EnvironmentObject var keyboardReciver: KeyboardReciver
    
    var letter: String?
    var icon: Image?
    var sign: String?
    @Binding var state: BoxState
    var isSpecialSign: Bool = false
    @State var isTapped: Bool = false
    
    init(letter: String, state: Binding<BoxState>) {
        self.letter = letter
        self._state = state
    }
    
    init(icon: Image, sign: String) {
        self.icon = icon
        self.sign = sign
        self._state = .constant(.neutral)
    }
    
    var body: some View {
        if state != .invalid {
        GeometryReader { g in
            if let letter {
                Rectangle()
                    .foregroundColor(state.color)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray, radius: 2)
                    .overlay {
                        Text(letter)
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                    }
                    .frame(height: g.size.width*1.5)
            }
            if let icon {
                Rectangle()
                    .foregroundColor(Color("letterbox.neutral"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .gray, radius: 2)
                    .overlay {
                        icon
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                    }
            }
        }
        .scaleEffect(isTapped ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.08), value: isTapped)
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            isTapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                isTapped = false
            }
            if let letter {
                keyboardReciver.sign = letter
            }
            if let sign {
                keyboardReciver.sign = sign
            }
        }
        } else {
            GeometryReader { g in
                if let letter {
                    Rectangle()
                        .foregroundColor(Color("keyboard.incorrect"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray, radius: 2)
                        .overlay {
                            Text(letter)
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                        }
                        .frame(height: g.size.width*1.5)
                }
            }
        }
    }
}


