//
//  SettingsVM.swift
//  Letterly
//
//  Created by Konrad on 27/07/2024.
//

import Foundation

class SettingsVM : ObservableObject {
    
    var languageManager = LanguageManager.shared
    
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
    
}
