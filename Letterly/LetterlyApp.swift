//
//  LetterlyApp.swift
//  Letterly
//
//  Created by Konrad on 18/02/2024.
//

import SwiftUI
import Firebase


@main
struct LetterlyApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        FirebaseApp.configure()
        print("Configured Firebase!")
    }
    
    var body: some Scene {
        WindowGroup {
            if let isSignedIn = appState.isSignedIn {
                if isSignedIn {
                    MainScreen()
                        .environment(\.colorScheme, .light)
                        .environment(\.font, Font.custom("Rubik-VariableFont_wght", size: 14))
                        .environmentObject(appState)
                } else {
                    LoginView()
                        .environmentObject(appState)
                }
            }
            else {
                Text("Waiting for connection...")
            }
        }
    }
}


class AppState: ObservableObject {
    @Published var isSignedIn: Bool?
    @Published var authUser: AuthResultModel? = nil

    init() {
        AuthenticationManager.shared.getAuthenticatedUser { [weak self] user in
            DispatchQueue.main.async {
                self?.authUser = user
                self?.isSignedIn = self?.authUser != nil
            }
        }
    }
    
    func signOut() {
        isSignedIn = false
        authUser = nil
    }
}
