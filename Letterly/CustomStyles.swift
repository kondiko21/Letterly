//
//  CustomStyles.swift
//  Letterly
//
//  Created by Konrad on 15/08/2024.
//

import Foundation
import SwiftUI

struct AppButton: ButtonStyle {
    
    var weight : Font.Weight
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color(.gray))
            .fontWeight(weight)
            .background(Color("letterbox.neutral"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .gray, radius: 2)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct AppTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .foregroundStyle(Color(.gray))
            .background(Color("letterbox.neutral"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .gray, radius: 2)
    }
}
