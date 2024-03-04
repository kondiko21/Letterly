//
//  ContentView.swift
//  Letterly
//
//  Created by Konrad on 18/02/2024.
//

import SwiftUI
import ExytePopupView
 

struct GameView: View {
    
    @StateObject var viewModel : GameViewVM = GameViewVM()
    @StateObject var keyboardReciver : KeyboardReciver = KeyboardReciver()

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
                    ForEach(0...4, id: \.self) { i in
                        GuessWordView(id: i)
                            .environmentObject(self.viewModel)
                            .frame(height:g.size.width*0.8/5)
                    }
                }
                .onReceive(keyboardReciver.$sign) { sign in
                        viewModel.recivedSign(sign)
                }
                
                Spacer()
                KeyboardView()
                    .frame(height: (g.size.width*0.9/10*4*1.5)+(g.size.width*0.1/10*3))
                    .environmentObject(keyboardReciver)
                    .environmentObject(viewModel)
                }
        }
        .task {
            await viewModel.wordBase.importWords(language: "pl_PL")
            viewModel.prepareNewGame()
        }
        .popup(isPresented: $viewModel.isNotExistAlertPresented){
            Text("Wprowadzone słowo nie istnieje!")
                .frame(width:g.size.width*0.8, height: 60)
                .background(Color(red: 0.9, green: 0.0, blue: 0.0))
                .cornerRadius(10)
        } customize: {
            $0
                .type (.floater(verticalPadding: 60, horizontalPadding: 20, useSafeAreaInset: false))
                .position(.bottom)
                .dragToDismiss(true)
                .autohideIn(1.5)
        }
        .popup(isPresented: $viewModel.isCompleteViewPresented){
            VStack {
                Text("Wygrana!").foregroundStyle(Color.gray).font(.largeTitle)
                Button {
                    viewModel.isCompleteViewPresented = false
                } label: {
                    Text("Następna runda")
                        .padding()
                        .bold()
                }
            }
            .shadow(radius: 10)
            .frame(width:g.size.width*0.8, height: 200)
            .background(Color("letterbox.neutral"))
            .cornerRadius(10)

        } customize: {
            $0.dragToDismiss(true)
        }
        }
    }
}

#Preview {
    GameView()
}
