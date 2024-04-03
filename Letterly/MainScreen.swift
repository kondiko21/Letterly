//
//  MainScreen.swift
//  Letterly
//
//  Created by Konrad on 13/03/2024.
//

import SwiftUI

struct MainScreen: View {
    
    @State var gameModeOptions: [String] = GameMode.allCases.map { $0.displayName }
    @State var selectedGameMode: String = GameMode.allCases[0].displayName
    
    @StateObject var gameConfiguration: GameConfiguration = GameConfiguration()

    @State var rankingGameOn: String = "Yes"
    @State var rankingGameOptions: [String] = ["Yes", "No"]
    var names = ["Marysia", "Adaś", "Krzyś", "John", "Joe", "Monica","Rachel"]
    @State var startTapped: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack {
                    Text("LETTERLY")
                        .logoStyle()
                    
                    Text("Ranking")
                        .font(.title)
                        .foregroundStyle(.gray)
                        .opacity(0.9)
                        .padding(.bottom, 5)
                    
                    VStack(spacing: 0) {
                        Divider().padding(5).padding([.leading, .trailing], 50)
                        ForEach(names.indices) { i in
                            HStack {
                                Text("\(i+1). \(names[i])")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                    .opacity(0.9)
                                Spacer()
                                Text("\(50-i*5) wins")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                    .opacity(0.9)
                            }.padding([.leading, .trailing], 70)
                            
                            Divider().padding(5).padding([.leading, .trailing], 50)
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
}

struct AppButton: ButtonStyle {
    
    var weight : Font.Weight
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundStyle(Color(.gray))
            .fontWeight(weight)
            .background(Color("letterbox.neutral"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .gray, radius: 2)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
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

#Preview {
    MainScreen()
}
