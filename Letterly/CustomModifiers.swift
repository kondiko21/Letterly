//
//  CustomModifiers.swift
//  Letterly
//
//  Created by Konrad on 13/03/2024.
//

import SwiftUI

struct Logo: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 35))
            .fontWeight(.heavy)
            .foregroundStyle(Color(.gray))
            .shadow(radius: 2)
            .padding()
    }
}

extension View {
    func logoStyle() -> some View {
        modifier(Logo())
    }
}
