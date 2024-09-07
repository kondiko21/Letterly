//
//  SettingsView.swift
//  Letterly
//
//  Created by Konrad on 27/07/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel = SettingsVM()
    @ObservedObject var appState = AppState()
    
    var body: some View {
        ZStack {
            NavigationLink(destination: LoginView().navigationBarHidden(true), isActive: $viewModel.isSignedOut) {
            EmptyView()
            }
            Color("background").ignoresSafeArea()
            VStack(spacing: 0){
                ZStack {
                    HStack {
                        Text("LETTERLY")
                            .logoStyle()
                    }
                    HStack {
                        NavigationLink {
                            NavigationLazyView(MainScreen().toolbar(.hidden))
                        } label: {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Back")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.gray)
                                .bold()
                            }
                        }
                        Spacer()
                    }
                    .padding([.leading, .trailing], 20)
                }
                Form {
                    Picker("Game language", selection: $viewModel.selectedGameLanguage) {
                        ForEach(viewModel.languages, id: \.self) { lang in
                                Text(lang)
                        }
                    }
                    .environment(\.colorScheme, .light)
                    .bold()
                    .pickerStyle(.navigationLink)

                    Picker("Interface language", selection: $viewModel.selectedGameLanguage) {
                        ForEach(viewModel.languages, id: \.self) { lang in
                                Text(lang)
                        }
                    }
                    .environment(\.colorScheme, .light)
                    .bold()
                    .pickerStyle(.navigationLink)
                    
                }
                .environment(\.colorScheme, .light)
                .scrollContentBackground(.hidden)
                .padding(.top, -20)
                
                Button {
                    do {
                        try viewModel.logOut()
                        appState.signOut()
                    } catch {
                        print(error)
                    }
                } label: {
                    Text("Log Out")
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing], 100)
                }.buttonStyle(AppButton(weight: .bold))
                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView()
}
