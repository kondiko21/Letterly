//
//  CustomSegmentedPicker.swift
//  Letterly
//
//  Created by Konrad on 14/03/2024.
//

import SwiftUI

struct CustomSegmentedPicker: View {
    
    var options: [String]
    @Binding var selectedValue: String
    @State var selected = 0
    
    init(options: [String], selectedValue: Binding<String>) {
        self.options = options
        self._selectedValue = selectedValue
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            RoundedRectangle(cornerRadius: 10.0)
                .shadow(radius: 1)
                .foregroundColor(Color("letterbox.neutral"))
                .overlay {
                    ZStack {
                        HStack(spacing:0) {
                            RoundedRectangle(cornerRadius: 10.0)
                                .frame(width: geometry.size.width*0.95/CGFloat(options.count),
                                    height: geometry.size.height-geometry.size.width*0.05/CGFloat(options.count))
                                .foregroundColor(Color("keyboard.special").opacity(0.5))
                                .shadow(radius: 2)
                            .padding(.leading, geometry.size.width*0.05/CGFloat(options.count*4))
                            .offset(x: CGFloat(selected) * (geometry.size.width / CGFloat(options.count))+geometry.size.width*0.05/CGFloat(options.count*2))
                            .animation(.easeInOut(duration: 0.3), value: selected)
                            Spacer()
                        }
                        HStack(spacing:0) {
                            ForEach(options, id: \.self) { option in
                                Text(option)
                                    .frame(width: geometry.size.width/CGFloat(options.count),
                                           height: geometry.size.height)
                                    .foregroundStyle(.black)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        if let selection = options.firstIndex(of: option) {
                                            selected = selection
                                            selectedValue = options[selection]
                                        }
                                    }
                            }
                        }.padding(.leading, geometry.size.width*0.05/CGFloat(options.count*2))
                    }
                }
                
        })
    }
}

#Preview {
    
    CustomSegmentedPicker(options: ["Opcja 1", "Opcja 2", "Opcja 3"], selectedValue: .constant("Opcja 1"))
        .frame(width:350, height: 50)
}
