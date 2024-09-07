//
//  SettingsView.swift
//  Letterly
//
//  Created by Konrad on 27/07/2024.
//

import SwiftUI
import ExytePopupView

struct RegisterView: View {
    
    @ObservedObject private var viewModel = RegisterViewViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { g in
                ZStack {
                    NavigationLink(destination: MainScreen().navigationBarHidden(true), isActive: $viewModel.isSignedIn) {
                        EmptyView()
                    }
                    Color("background").ignoresSafeArea()
                    VStack(spacing: 0){
                        ZStack {
                            HStack {
                                Text("LETTERLY")
                                    .logoStyle()
                            }
                        }
                        Spacer()
                            .frame(height:50)
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(AppTextFieldStyle())
                            .frame(width: g.size.width*0.9)
                            .padding([.bottom])
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(AppTextFieldStyle())
                            .frame(width: g.size.width*0.9)
                            .padding([.bottom])
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(AppTextFieldStyle())
                            .frame(width: g.size.width*0.9)
                            .padding([.bottom])
                        Spacer()
                        Button {
                            viewModel.signUp()
                        } label: {
                            Text("Create account")
                                .padding([.top, .bottom])
                                .frame(width: g.size.width*0.9)
                        }
                        .buttonStyle(AppButton(weight: .bold))
                        
                        NavigationLink {
                            LoginView().navigationBarHidden(true)
                        } label: {
                            Text("Already have an account?\n Login now!")
                                .padding([.leading, .trailing], 90)
                                .padding(.top, 15)
                                .foregroundStyle(.gray)
                                .bold()
                        }

                    }
                }.overlay {
                    if viewModel.isLoadingWheelActive {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    }
                }
                
                .popup(isPresented: $viewModel.isErrorDisplayed){
                    Text("Incorrect data!")
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
                .environment(\.colorScheme, .light)
                
            }
        }
    }
}

@MainActor
final class RegisterViewViewModel : ObservableObject {
    
    @Published var isSignedIn: Bool = false
    @Published var isLoadingWheelActive: Bool = false
    @Published var isErrorDisplayed: Bool = false
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signUp() {
        isLoadingWheelActive = true
        guard !email.isEmpty, !password.isEmpty else {
            //TODO: Missing data handling
            isErrorDisplayed = true
            print("No email or password found.")
            return
        }
        Task {
            do {
                try await AuthenticationManager.shared.createUser(email: email, password: password, username: username)
                isLoadingWheelActive = false
                isSignedIn = true
            } catch {
                isLoadingWheelActive = false
                isErrorDisplayed = true
                print("Error: \(error)")
            }
        }
    }
    
}

#Preview {
    LoginView()
}
