//
//  LanguageManager.swift
//  Letterly
//
//  Created by Konrad on 29/07/2024.
//

import Foundation

class LanguageManager {
    
    static let shared = LanguageManager()
    
    private init() { }
    
    var selectedGameLanguage: String = (UserDefaults.standard.string(forKey: "gameLanguage") ?? "English")
    {
        didSet {
            UserDefaults.standard.set(selectedGameLanguage, forKey: "gameLanguage")
        }
    }
    var selectedGameLangCode: String {
        languageCodeFor(name: self.selectedGameLanguage)
    }

    
    func languageCodeFor(name: String) -> String {
        switch name {
            case "English":
                return "en_EN"
            case "Polski":
                return "pl_PL"
            default:
                return "en_EN"
        }
    }
    
    private func languageDisplayNameFor(code: String) -> String {
        switch code {
            case "en_EN":
                return "English"
            case "pl_PL":
                return "Polski"
            default:
                return "English"
            }
    }
    
    func getAvailableLanguages() -> [String] {
        return ["English", "Polski"]
    }
    
}

extension LanguageManager {
    
    var keyboardSpecialSigns: [String:String] {
        [
            "pl_PL":"ĘĄŁŚÓŻŹĆŃ",
            "en_EN":""
        ]
    }
    
    
}
