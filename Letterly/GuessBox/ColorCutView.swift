//
//  ColorCutView.swift
//  Letterly
//
//  Created by Konrad on 18/02/2024.
//

import SwiftUI

struct ColorCutView: View {
    
    @State var primaryColor : Color
    @State var nextColors : [(Color, CGFloat)] = [] // [Color:Progress]
    @ObservedObject var colorStore: ColorStore
    
    init(color: Color) {
        self._primaryColor = State<Color>(initialValue: color)
        self.colorStore = ColorStore(color: color)
    }
    
    var body: some View {
        Rectangle()
            .foregroundColor(primaryColor)
            .overlay(content: {
                ZStack {
                    ForEach(nextColors.indices, id: \.self) { i in
                        CutShape(progress: self.nextColors[i].1)
                            .foregroundStyle(self.nextColors[i].0)
                    }
                }
            })
            .onReceive(colorStore.$color, perform: { color in
                self.nextColors.append((color, 0))
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.nextColors[self.nextColors.count-1].1 = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.primaryColor = self.nextColors[0].0
                    self.nextColors.remove(at: 0)
                }
            })
    }
}

struct CutShape: Shape {

    var progress: CGFloat
    
    var animatableData: CGFloat {
        get { return progress }
        set { self.progress = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0)) // Top Left
        path.addLine(to: CGPoint(x: (rect.width+rect.width/4) * progress, y: 0)) // Top Right
        path.addLine(to: CGPoint(x: rect.width * progress, y: rect.height)) // Bottom Right
        path.addLine(to: CGPoint(x: 0, y: rect.height)) // Bottom Left
        path.closeSubpath() // Close the Path
        return path
    }
}

class ColorStore: ObservableObject {
    @Published var color: Color
    
    init(color: Color) {
        self.color = color
    }
}

#Preview {
    ColorCutView(color: .gray)
}
