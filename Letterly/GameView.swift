//
//  ContentView.swift
//  Letterly
//
//  Created by Konrad on 18/02/2024.
//

import SwiftUI

struct ContentView: View {
    var colors: [Color] = [.blue, .red, .green, .orange]
    @State var index: Int = 0

    var body: some View {
        GeometryReader { g in
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 0){
                HStack(content: {
                    Text("LETTERLY")
                        .font(.system(size: 35))
                        .fontWeight(.heavy)
                        .foregroundStyle(Color(.gray))
                        .shadow(radius: 2)
                        .padding()
                })
                VStack(spacing: g.size.width*(1-0.8)/5) {
                    GuessWordView().frame(height:g.size.width*0.8/5)
                    GuessWordView().frame(height:g.size.width*0.8/5)
                    GuessWordView().frame(height:g.size.width*0.8/5)
                    GuessWordView().frame(height:g.size.width*0.8/5)
                    GuessWordView().frame(height:g.size.width*0.8/5)
                }
                Spacer()
                KeyboardView().frame(height: (g.size.width*0.9/10*4*1.5)+(g.size.width*0.1/10*3))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
