//
//  KeyboardView.swift
//  Letterly
//
//  Created by Konrad on 21/02/2024.
//

import SwiftUI

struct KeyboardView: View {
    
    let rows = [
        "QWERTYUIOP".map {String($0)},
        "ASDFGHJKL".map {String($0)},
        "ZXCVBNM".map {String($0)},
        "ĘĄŚÓŻŹĆŃ".map {String($0)}
    ]
    
    var body: some View {
        GeometryReader { g in
            VStack(alignment: .center, spacing:0) {
                HStack(spacing:0) {
                    ForEach(rows[0], id: \.self) { letter in
                        ButtonView(letter: letter)
                            .frame(width: g.size.width*0.9/10)
                            .padding([.trailing,.leading], g.size.width*0.1/22)
                    }
                }
                HStack(spacing:0) {
                    ForEach(rows[1], id: \.self) { letter in
                        ButtonView(letter: letter)
                            .frame(width: g.size.width*0.9/10)
                            .padding([.trailing,.leading], g.size.width*0.1/22)
                    }
                }
                HStack(spacing:0) {
                    ButtonView(icon: Image(systemName: "checkmark"))
                        .frame(width: g.size.width*0.9/10*1.5, height: g.size.width*0.9/10*1.5)
                        .padding([.trailing,.leading], g.size.width*0.1/22)
                    ForEach(rows[2], id: \.self) { letter in
                        ButtonView(letter: letter)
                            .frame(width: g.size.width*0.9/10)
                            .padding([.trailing,.leading], g.size.width*0.1/22)
                    }
                    ButtonView(icon: Image(systemName: "delete.left"))
                        .frame(width: g.size.width*0.9/10*1.5, height: g.size.width*0.9/10*1.5)
                        .padding([.trailing,.leading], g.size.width*0.1/22)
                }
                HStack(spacing:0) {
                    ForEach(rows[3], id: \.self) { letter in
                        ButtonView(letter: letter)
                            .frame(width: g.size.width*0.9/10)
                            .padding([.trailing,.leading], g.size.width*0.1/22)                    }
                }
                
            }
            .padding([.leading, .trailing], g.size.width*0.1/22)
        }
    }
}

#Preview {
    KeyboardView()
}

struct ButtonView: View {
    
    var letter: String?
    var icon: Image?
    var isSpecialSign: Bool = false
    @State var isTapped: Bool = false
    
    init(letter: String) {
        self.letter = letter
    }
    
    init(icon: Image) {
        self.icon = icon
        self.isSpecialSign = true
    }
    
    var body: some View {
        GeometryReader { g in
            if let letter {
                Rectangle()
                    .foregroundColor(Color("letterbox.neutral"))
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
        }
    }
}
