//
//  SettingsView.swift
//  Letterly
//
//  Created by Konrad on 27/07/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel = SettingsVM()
    
    var body: some View {
        ZStack {
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
                            Text("Back")
                                .font(.system(size: 25))
                                .foregroundStyle(.gray)
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

                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView()
}
