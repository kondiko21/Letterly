//
//  MainScreen.swift
//  Letterly
//
//  Created by Konrad on 13/03/2024.
//

import SwiftUI
import FirebaseFirestore

struct MainScreen: View {
    
    @State var gameModeOptions: [String] = GameMode.allCases.map { $0.displayName }
    @State var selectedGameMode: String = GameMode.allCases[0].displayName
    
    @StateObject var gameConfiguration: GameConfiguration = GameConfiguration()

    @State var rankingGameOn: String = "Yes"
    @State var rankingGameOptions: [String] = ["Yes", "No"]
    var names = ["Marysia", "Adaś", "Krzyś", "John", "Joe", "Monica","Rachel"]
    var userManager = UsersManager()
    @State var ranking: [String:Int] = [:]
    @State var startTapped: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack {
                    ZStack {
                        HStack {
                            Text("LETTERLY")
                                .logoStyle()
                        }
                        HStack {
                            Spacer()
                            NavigationLink {
                                SettingsView().navigationBarHidden(true)
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 25))
                                    .foregroundStyle(.gray)
                                    .padding(.trailing, 20)
                            }
                        }
                    }
                    
                    Text("Ranking")
                        .font(.title)
                        .foregroundStyle(.gray)
                        .opacity(0.9)
                        .padding(.bottom, 5)
                    
                    VStack(spacing: 0) {
                        //RANKING LIST
                        Divider().padding(5).padding([.leading, .trailing], 50)
                        if !ranking.isEmpty {
                            ForEach(allKeys, id: \.self) { key in
                                HStack {
                                    Text("\(1). \(key)")
                                        .font(.headline)
                                        .foregroundStyle(.gray)
                                        .opacity(0.9)
                                    Spacer()
                                    Text("\(binding(for: key).wrappedValue) wins")
                                        .font(.headline)
                                        .foregroundStyle(.gray)
                                        .opacity(0.9)
                                }.padding([.leading, .trailing], 20)
                                
                                Divider().padding(5).padding([.leading, .trailing], 50)
                            }
                        } else {
                            ProgressView().progressViewStyle(CircularProgressViewStyle())
                        }
                    }.onAppear {
                        Task {
                            print("Read")
                            ranking = await userManager.getRanking(limit: 5)
                            print("Ranking \(ranking)")
                        }
                    }
                    
                    Spacer()
                    //MARK: Game settings
                    Text("Difficulty level")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .opacity(0.9)
                    
                    CustomSegmentedPicker(options: gameModeOptions, selectedValue: $gameConfiguration.selectedGameMode)
                        .frame(width: geo.size.width*0.9, height: 50)
                        .padding(.bottom, 5)
                    
                    Text("Easy - incorrect letters still can me used while guessing\n\nHard - incorrect letters can no longer be used while guessing the word")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .padding(0)
                        .frame(width: geo.size.width*0.9)
                        .padding(.bottom, 5)
                    
                    Text("Ranking game")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .opacity(0.9)
                    
                    CustomSegmentedPicker(options: rankingGameOptions, selectedValue: $gameConfiguration.selectedIsRanked)
                        .frame(width: geo.size.width*0.9, height: 50)
                        .padding(.bottom, 50)
                    
                    NavigationLink {
                        NavigationLazyView(GameView(gameConfiguration: gameConfiguration).toolbar(.hidden))
                    } label: {
                        Text("START")
                            .padding()
                            .padding([.leading, .trailing], 100)
                    }
                    .buttonStyle(AppButton(weight: .bold))

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("background"))
            }
            .toolbar(.hidden)
        }
        
    }
    
    private var allKeys: [String] {
            return ranking.keys.sorted().map { String($0) }
        }
    
    private func binding(for key: String) -> Binding<Int> {
            return Binding(get: {
                return self.ranking[key] ?? 0
            }, set: {
                self.ranking[key] = $0
            })
        }
}

class GameConfiguration: ObservableObject {
    
    var gameMode: GameMode = .easy
    var isRanked: Bool = false
    
    @Published var selectedGameMode: String = "Easy" {
        didSet {
            switch selectedGameMode {
            case "Easy":
                gameMode = .easy
            case "Hard":
                gameMode = .hard
            default:
                gameMode = .easy
            }
        }
    }
    @Published var selectedIsRanked: String = "No" {
        didSet {
            switch selectedIsRanked {
            case "Yes":
                self.isRanked = true
            case "No":
                self.isRanked = false
            default:
                self.isRanked = false
            }
        }
    }
    
}

enum GameMode: CaseIterable {
    
    case easy
    case hard
    
    var displayName: String {
        
        switch self {
        case .easy:
            return "Easy"
        case .hard :
            return "Hard"
        }
    }
    
}
struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct UsersManager {
    
    
    let db = Firestore.firestore()
    func getRanking(limit: Int) async -> [String:Int] {
        
        var ranking: [String:Int] = [:]
        var result: [String:Int] = [:]
        
        do {
            let rankingRef = db.collection("ranking")
            rankingRef.order(by: "winningGames").limit(to: 5)
            let rankingSnapshot = try await rankingRef.getDocuments()
            for document in rankingSnapshot.documents {
                let id = document.documentID
                let data = document.data()["winningGames"] as! Int
                ranking[id] = data
            }
            let usersRef = db.collection("users")
            usersRef.whereField("uid", in: ranking.keys.sorted())
            let usersSnapshot = try await usersRef.getDocuments()
            for document in usersSnapshot.documents {
                let id = document.data()["uid"] as! String
                let name = document.data()["username"] as! String
                let resultForId = ranking[id]
                result[name] = resultForId
            }
            
            return Dictionary(uniqueKeysWithValues: result.sorted(by: { $0.key < $1.key }))
        } catch {
            print("Error getting documents: \(error)")
            return [:]
        }
        
    }
    
    
}

#Preview {
    MainScreen()
}
