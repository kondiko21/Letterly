//
//  RandomWordGenerator.swift
//  Letterly
//
//  Created by Konrad on 27/02/2024.
//

import Foundation

class WordsManager {
    
    var words: [String]?
    
    func importWords(language: String) async {
        if let filename = Bundle.main.path(forResource: "pl_PL", ofType: "txt") {
            let contents = try! String(contentsOfFile: filename)
            self.words = contents.split(separator:"\n").map { String($0) }
        }
    }
    
    enum WordManagerError: Error {
        case missingData
        case incorrectData
    }
    
    func generateRandomWord() throws -> String {
        if let words {
            let random: Int = Int.random(in: 0..<words.count)
            return words[random].uppercased()
        } else {
            throw WordManagerError.missingData
        }
    }
    
}
