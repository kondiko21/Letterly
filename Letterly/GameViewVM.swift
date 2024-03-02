//
//  GameViewVM.swift
//  Letterly
//
//  Created by Konrad on 22/02/2024.
//

import Foundation
import UIKit

class GameViewVM : ObservableObject {
    
    @Published var wordLength: Int = 5
    @Published var wordGuessAttempts: [[LetterStateVM]] = []
    @Published var round: Int = 0
    @Published var isNotExistAlertPresented = false
    @Published var isCompleteViewPresented = false
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
                if wordGuessAttempts[round][activeBox].letter == "" && activeBox != 0 {
                    activeBox -= 1
                    recivedSign("delete")
                }
                wordGuessAttempts[round][activeBox].letter = ""
            case "confirm":
                verifyResult()
            default:
                wordGuessAttempts[round][activeBox].letter = sign
                if activeBox < 4 {
                    activeBox += 1
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
        wordGuessAttempts = []
        for _ in 0...4 {
            wordGuessAttempts.append([LetterStateVM](repeating: LetterStateVM(), count: wordLength))
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
    
    private func verifyResult() {
        var result: RoundResults = checkTypedWord()
        
        switch result {
        case .incorrectData:
            isNotExistAlertPresented = true
        case .partlyWin:
            nextRound()
        case .winning:
            isCompleteViewPresented = true
            prepareNewGame()
        }
    }
    
    private func checkTypedWord() -> RoundResults {
        let typedWord = wordGuessAttempts[round].compactMap { $0.letter } as [String]
        var correctLettersAmunt = 0
        if isReal(word: typedWord.joined(), lang: "pl_PL") {
            for i in 0...4 {
                print(word[i]+" "+wordGuessAttempts[round][i].letter)
                if word[i] == wordGuessAttempts[round][i].letter {
                    wordGuessAttempts[round][i].state = .correct
                    setKeyboard(buttonLetter: word[i], state: .correct)
                    correctLettersAmunt += 1
                } else if word.contains(wordGuessAttempts[round][i].letter) {
                    wordGuessAttempts[round][i].state = .partlyCorrect
                } else {
                    wordGuessAttempts[round][i].state = .invalid
                }
                self.setKeyboard(buttonLetter: self.wordGuessAttempts[self.round][i].letter , state: self.wordGuessAttempts[self.round][i].state)
            }
            if correctLettersAmunt == wordLength {
                return .winning
            } else {
                return .partlyWin(correctAmount: correctLettersAmunt)
            }
        } else {
            return .incorrectData
        }
    }
    
    enum RoundResults {
        case incorrectData
        case winning
        case partlyWin(correctAmount: Int)
    }
    
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
        let checker = UITextChecker()
        if word == "" || word.count < 5 { return false }
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word.lowercased(), range: range, startingAt: 0, wrap: false, language: lang)
        
        return misspelledRange.location == NSNotFound
    }
    
}


