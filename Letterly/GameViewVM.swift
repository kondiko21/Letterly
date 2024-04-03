//
//  GameViewVM.swift
//  Letterly
//
//  Created by Konrad on 22/02/2024.
//

import Foundation
import UIKit
import SwiftUI

class GameViewVM : ObservableObject {
    
    @Published var wordLength: Int = 5
    @Published var typingEnabled = true //Determines if keyboard is working - used during async await
    @Published var wordGuessAttempts: [[LetterStateVM]] = []
    @Published var round: Int = 0
    @Published var isNotExistAlertPresented = false
    @Published var isCompleteViewPresented = false
    @Published var isGameOver = false
    var activeBox: Int = 0
    
    var wordBase = WordsManager()
    
    @Published var word: [String] = "OGIEŃ".map{String($0)}
    @Published var keyboradRows: [[LetterStateVM]] = [
        "QWERTYUIOP".map {LetterStateVM(String($0))},
        "ASDFGHJKL".map {LetterStateVM(String($0))},
        "ZXCVBNM".map {LetterStateVM(String($0))},
        "ĘĄŁŚÓŻŹĆŃ".map {LetterStateVM(String($0))}
    ]
    
    init() {
        for _ in 0...4 {
            wordGuessAttempts.append([LetterStateVM](repeating: LetterStateVM(), count: wordLength))
        }
    }
    
    func recivedSign(_ sign: String) {
        if !sign.isEmpty {
            switch sign {
            case "delete":
                if activeBox != 5 {
                    if wordGuessAttempts[round][activeBox].letter == "" && activeBox != 0 {
                        activeBox -= 1
                        recivedSign("delete")
                    }
                } else {
                    activeBox -= 1
                    recivedSign("delete")
                }
                wordGuessAttempts[round][activeBox].letter = ""
            case "confirm":
                Task {
                    await MainActor.run {
                        typingEnabled = false
                        print("Typing disabled")
                    }
                    let result: RoundResult = await checkTypedWord()
                    await MainActor.run {
                        if result.result == .incorrectData {
                            isNotExistAlertPresented = true
                        }
                        wordGuessAttempts[round] = result.correctedLetters
                        if result.result != .incorrectData {
                            for letter in result.correctedLetters {
                                setKeyboard(buttonLetter: letter.letter, state: letter.state)
                            }
                        }
                        typingEnabled = true
                        print("Typing enabled")
                    }
                    try await Task.sleep(nanoseconds: 1_500_000_000)
                    await verifyResult(result: result.result)
                }
                
            default:
                if activeBox < 5 {
                    wordGuessAttempts[round][activeBox].letter = sign
                    if activeBox < 5 {
                        activeBox += 1
                    }
                }
            }
        }
    }
    private func nextRound() {
        if round < 4 {
            round += 1
            activeBox = 0
        }
    }
    
    func prepareNewGame() {
        var _ = isReal(word: "aaaaa", lang: "pl_PL") //Solving problem (bug probably) which first execution always return true
        
        for i in 0...4 {
            wordGuessAttempts[i] = [LetterStateVM](repeating: LetterStateVM(), count: wordLength)
        }
        keyboradRows = [
            "QWERTYUIOP".map {LetterStateVM(String($0))},
            "ASDFGHJKL".map {LetterStateVM(String($0))},
            "ZXCVBNM".map {LetterStateVM(String($0))},
            "ĘĄŁŚÓŻŹĆŃ".map {LetterStateVM(String($0))}
        ]
        
        do {
            try word = wordBase.generateRandomWord().map{String($0)}
            print("Word: "+word.joined(separator: ""))
        } catch WordsManager.WordManagerError.missingData {
            print("No data imported")
        } catch {
            print("Data are incorrect")
        }
        
        round = 0
        activeBox = 0
    }
    
    @MainActor
    private func verifyResult(result: RoundResults) async {
        switch result {
        case .incorrectData:
            print("Incorrect data")
        case .partlyCorrect:
            if round != 4 {
                nextRound()
            } else {
                isGameOver = true
            }
        case .winning:
            isCompleteViewPresented = true
        }
    }
    
    private func checkTypedWord() -> RoundResult {
        let typedWord = wordGuessAttempts[round].compactMap { $0.letter } as [String]
        if isReal(word: typedWord.joined().lowercased(), lang: "pl_PL") {
            
            var result = verifyWord()
            
            if result.0 == wordLength {
                return RoundResult(correctAmount: wordLength, correctedLetters: result.1, result: .winning)
            } else {
                return RoundResult(correctAmount: result.0, correctedLetters: result.1, result: .partlyCorrect)
            }
        } else {
            return RoundResult(correctAmount: 0, correctedLetters: wordGuessAttempts[round], result: .incorrectData)
        }
    }
    
    @MainActor
    private func setKeyboard(buttonLetter: String, state: BoxState) {
        for rowIndex in keyboradRows.indices {
            for buttonIndex in keyboradRows[rowIndex].indices {
                if keyboradRows[rowIndex][buttonIndex].letter == buttonLetter {
                    if state == .partlyCorrect {
                        if keyboradRows[rowIndex][buttonIndex].state != .correct {
                            keyboradRows[rowIndex][buttonIndex].state = state
                        }
                    } else {
                        keyboradRows[rowIndex][buttonIndex].state = state
                    }
                    break
                }
            }
        }
    }
    
    private func isReal(word: String, lang: String) -> Bool {
        if word == "" || word.count < 5 { return false }
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let checker: UITextChecker = UITextChecker()
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: lang)
        
        if misspelledRange.location == NSNotFound {
            return true
        } else {
            return false
        }
    }

    func verifyWord() -> (Int, [LetterStateVM]) {
        var newStates = wordGuessAttempts[round]
        var letterSet : [String:Int] = [:]
        var correctLettersAmunt: Int = 0
        
        for (id, letter) in word.enumerated() {
            if let letterCounter = letterSet[letter] {
                letterSet[word[id]]! += 1
            } else {
                letterSet[letter] = 1
            }
        }
        
        for i in 0...4 {
            if word[i] == wordGuessAttempts[round][i].letter {
                newStates[i].state = .correct
                correctLettersAmunt += 1
                letterSet[wordGuessAttempts[round][i].letter]? -= 1
            } else if word.contains(wordGuessAttempts[round][i].letter) {
                if let letterData = letterSet[wordGuessAttempts[round][i].letter] {
                    if letterData > 0 {
                        newStates[i].state = .partlyCorrect
                        letterSet[wordGuessAttempts[round][i].letter]? -= 1
                    } else {
                        newStates[i].state = .invalid
                    }
                }
            } else {
                newStates[i].state = .invalid
            }
        }
        return (correctLettersAmunt, newStates)
    }
}

struct LetterSetElement {
    
    var letter: String
    var count: Int
    
    init(letter: String, count: Int) {
        self.letter = letter
        self.count = count
    }
    
    mutating func add() {
        self.count = count + 1
    }
    
    mutating func remove() {
        self.count = count + 1
    }
    
}

struct RoundResult {
    
    var correctAmount: Int
    var correctedLetters: [LetterStateVM]
    var result: RoundResults
    
    init(correctAmount: Int, correctedLetters: [LetterStateVM], result: RoundResults) {
        self.correctAmount = correctAmount
        self.correctedLetters = correctedLetters
        self.result = result
    }
    
}

enum RoundResults {
    case incorrectData
    case winning
    case partlyCorrect
}
