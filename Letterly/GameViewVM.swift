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
    
    var checker: UITextChecker {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: 5)
            let misspelledRange = checker.rangeOfMisspelledWord(in: "aaaaa", range: range, startingAt: 0, wrap: false, language: "pl_PL")
            return checker
    }
    
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
                Task {
                    let result: RoundResult = await checkTypedWord()
                    await MainActor.run {
                        print(result.result)
                        if result.result == .incorrectData {
                            isNotExistAlertPresented = true
                        }
                        wordGuessAttempts[round] = result.correctedLetters
                    }
                    try await Task.sleep(nanoseconds: 1_500_000_000)
                    await verifyResult(result: result.result)
                }
                
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
            if round != 5 {
                nextRound()
            } else {
                prepareNewGame()
            }
        case .winning:
            isCompleteViewPresented = true
            prepareNewGame()
        }
    }
    
    private func checkTypedWord() async -> RoundResult {
        let typedWord = wordGuessAttempts[round].compactMap { $0.letter } as [String]
        var correctLettersAmunt = 0
        var newStates = wordGuessAttempts[round]
        if isReal(word: typedWord.joined().lowercased(), lang: "pl_PL") {
            print("Word exists")
            for i in 0...4 {
                if word[i] == wordGuessAttempts[round][i].letter {
                    newStates[i].state = .correct
                    await setKeyboard(buttonLetter: word[i], state: .correct)
                    correctLettersAmunt += 1
                } else if word.contains(wordGuessAttempts[round][i].letter) {
                    newStates[i].state = .partlyCorrect
                } else {
                    newStates[i].state = .invalid
                }
                await self.setKeyboard(buttonLetter: self.wordGuessAttempts[self.round][i].letter , state: self.wordGuessAttempts[self.round][i].state)
            }
            if correctLettersAmunt == wordLength {
                return RoundResult(correctAmount: wordLength, correctedLetters: newStates, result: .winning)
            } else {
                return RoundResult(correctAmount: correctLettersAmunt, correctedLetters: newStates, result: .partlyCorrect)
            }
        } else {
            return RoundResult(correctAmount: 0, correctedLetters: newStates, result: .incorrectData)
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
        
        print("Checking word:", word, "with language:", lang)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: lang)
        
        if misspelledRange.location == NSNotFound {
            print("Word exists.")
            return true
        } else {
            print("Word does not exist.")
            return false
        }
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


