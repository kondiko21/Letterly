//
//  SettingsView.swift
//  Letterly
//
//  Created by Konrad on 27/07/2024.
//

import SwiftUI
import ExytePopupView

struct LoginView: View {
    
    @ObservedObject private var viewModel = LoginViewViewModel()
    
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
                            viewModel.signIn()
                        } label: {
                            Text("Login")
                                .padding([.top, .bottom])
                                .frame(width: g.size.width*0.9)
                        }
                        .buttonStyle(AppButton(weight: .bold))
                        
                        NavigationLink {
                            RegisterView().navigationBarHidden(true)
                        } label: {
                            Text("Have no account yet? Register now!")
                                .padding([.leading, .trailing], 100)
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
final class LoginViewViewModel : ObservableObject {
    
    @Published var isSignedIn: Bool = false
    @Published var isLoadingWheelActive: Bool = false
    @Published var isErrorDisplayed: Bool = false
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signIn() {
        isLoadingWheelActive = true
        guard !email.isEmpty, !password.isEmpty else {
            //TODO: Missing data handling
            print("No email or password found.")
            isLoadingWheelActive = false
            return
        }
        Task {
            do {
                let returnedData = try await AuthenticationManager.shared.signIn(email: email, password: password)
                isLoadingWheelActive = false
                isSignedIn = true
                
            } catch AuthError.signIn {
                isLoadingWheelActive = false
                isErrorDisplayed = true
                print("Error")
            }
        }
    }
    
}

#Preview {
    LoginView()
}
