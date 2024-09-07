//
//  SettingsVM.swift
//  Letterly
//
//  Created by Konrad on 27/07/2024.
//

import Foundation
import FirebaseAuth

class SettingsVM : ObservableObject {
    
    var languageManager = LanguageManager.shared
    
    @Published var isSignedOut: Bool = false
    @Published var selectedGameLanguage: String = "Polish" {
        didSet {
            languageManager.selectedGameLanguage = selectedGameLanguage
        }
    }
    
    init() {
        self.selectedGameLanguage = languageManager.selectedGameLanguage
    }
    
    var languages: [String] {
        return languageManager.getAvailableLanguages()
    }
    
    func logOut() throws {
        do {
            try AuthenticationManager.shared.signOut()
            isSignedOut = true
        } catch {
            print("Error encourted during sign out!")
        }
    }
    
}
