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
    var gameConfiguration: GameConfiguration
    
    init( gameConfiguration: GameConfiguration) {
        self.gameConfiguration = gameConfiguration
    }

    var body: some View {
        GeometryReader { g in
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 0){
                ZStack {
                    HStack {
                        Text("LETTERLY")
                            .logoStyle()
                    }
                    HStack {
                        Spacer()
                        NavigationLink {
                            NavigationLazyView(MainScreen().toolbar(.hidden))
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 25))
                                .foregroundStyle(.gray)
                                .padding(.trailing, 20)
                        }
                    }
                }
                VStack(spacing: g.size.width*(1-0.8)/5) {
                    ForEach(0...4, id: \.self) { i in
                        GuessWordView(id: i )
                            .environmentObject(self.viewModel)
                            .frame(height:g.size.width*0.8/5)
                    }
                }
                .onReceive(keyboardReciver.$sign) { sign in
                        viewModel.recivedSign(sign)
                }
                
                Spacer()
                KeyboardView().environmentObject(gameConfiguration)
                    .frame(height: (g.size.width*0.9/10*4*1.5)+(g.size.width*0.1/10*3))
                    .environmentObject(keyboardReciver)
                    .environmentObject(viewModel)
                }
        }
        .blur(radius: (viewModel.isGameOver || viewModel.isCompleteViewPresented) ? 2 : 0)
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
            VStack(spacing: 0) {
                Text("YOU WON").foregroundStyle(Color.gray).font(.largeTitle)
                    .padding(.top, 50)
                Spacer()
                Text("HIDDEN WORD:").foregroundStyle(Color.gray)
                    .bold()
                    .font(.headline)
                    .padding(.bottom,0)
                Text(viewModel.word.joined()).logoStyle()
                    .padding(0)
                Spacer()
                
                NavigationLink {
                    MainScreen()
                } label: {
                    Text("MENU")
                        .padding([.leading, .trailing], 50)
                        .frame(maxWidth: .infinity)
                }.buttonStyle(AppButton(weight: .regular))
                    .frame(width:g.size.width*0.6)
                Button {
                    viewModel.prepareNewGame()
                    viewModel.isCompleteViewPresented = false
                } label: {
                    Text("PLAY AGAIN")
                        .fontWeight(.heavy)
                        .padding([.leading, .trailing], 50)
                        .frame(maxWidth: .infinity)
                }.buttonStyle(AppButton(weight: .bold))
                    .frame(width:g.size.width*0.6)
                    .padding()
                
            }
            .frame(width:g.size.width*0.8, height: g.size.height*0.5)
            .background(Color("background"))
            .cornerRadius(10)
            .compositingGroup()
            .shadow(radius: 10)

        }
        .popup(isPresented: $viewModel.isGameOver){
            VStack(spacing: 0) {
                Text("GAME OVER").foregroundStyle(Color.gray).font(.largeTitle)
                    .padding(.top, 50)
                Spacer()
                Text("HIDDEN WORD:").foregroundStyle(Color.gray)
                    .bold()
                    .font(.headline)
                    .padding(.bottom,0)
                Text(viewModel.word.joined()).logoStyle()
                    .padding(0)
                Spacer()
                
                NavigationLink {
                    MainScreen()
                } label: {
                    Text("MENU")
                        .padding([.leading, .trailing], 50)
                        .frame(maxWidth: .infinity)
                }.buttonStyle(AppButton(weight: .regular))
                    .frame(width:g.size.width*0.6)
                Button {
                    viewModel.prepareNewGame()
                    viewModel.isGameOver = false
                } label: {
                    Text("PLAY AGAIN")
                        .fontWeight(.heavy)
                        .padding([.leading, .trailing], 50)
                        .frame(maxWidth: .infinity)
                }.buttonStyle(AppButton(weight: .bold))
                    .frame(width:g.size.width*0.6)
                    .padding()
                
            }
            .frame(width:g.size.width*0.8, height: g.size.height*0.5)
            .background(Color("background"))
            .cornerRadius(10)
            .compositingGroup()
            .shadow(radius: 10)

        } customize: {
            $0.dragToDismiss(true)
        }
        }
    }
}

#Preview {
    GameView(gameConfiguration: GameConfiguration())
}
