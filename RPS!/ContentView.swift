//
//  ContentView.swift
//  RPS!
//
//  Created by Jorge Pardo on 23/9/23.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    let moves = ["rock", "paper", "scissors"]
    @State private var computerChoice = Int.random(in: 0..<3)
    @State private var shouldWin = Bool.random()
    @State private var backgroundMusicPlayer: AVAudioPlayer?

    
    @State private var score = 0
    @State private var questionCount = 1
    @State private var showingResults = false
    @State private var player: AVAudioPlayer?
    
    @State private var imageOpacities: [Double] = [0, 0, 0]
    @State private var renderKey = UUID()


    
    @State private var shuffledData: [(originalIndex: Int, shuffledValue: Int)] = Array(0..<3).enumerated().map { (index, value) in
        return (originalIndex: index, shuffledValue: value)
    }.shuffled()

    
    var body: some View {
        
        VStack {
            Spacer()
            
            Text("Si tu oponente ha sacado...")
            
            Image(moves[computerChoice])
                .resizable()
                   .scaledToFit()
                   .frame(width: 140)
            
            if shouldWin {
                Text ("¿Con qué ganas?")
                    .foregroundColor(.green)
                    .font(.title)
            } else {
                Text ("¿Con qué pierdes?")
                    .foregroundColor(.red)
                    .font(.title)
            }
            
            Group {
                HStack{
                    ForEach(shuffledData, id: \.originalIndex) { item in
                        Button(action: {
                            play(choice: item.originalIndex)
                        }) {
                            Image(moves[item.shuffledValue])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                                .opacity(imageOpacities[item.originalIndex])
                                .onAppear {
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        imageOpacities[item.originalIndex] = 1
                                    }
                                }
                        }
                    }
                }
            }.id(renderKey)

            Spacer()

            Text("Tu puntuación es: \(score)")
                .font(.subheadline)
            Spacer()
        }
        .onAppear {
//            playAudio(resourceName: "backgroundMusic.mp3", volume: 0.1, loop: true)
        }
        .alert("Partida terminada", isPresented: $showingResults ){
            Button("¿Quieres jugar otra vez?", action: reset)
        } message: {
            Text("Tu puntuación fue: \(score)")
        }
        
    }
    
    
    
    func play(choice: Int) {
        let winningMoves = [1, 2, 0]
        let didWin: Bool

        if shouldWin {
            didWin = choice == winningMoves[computerChoice]
        } else {
            didWin = winningMoves[choice] == computerChoice
        }
        
        if didWin {
            playAudio(resourceName: "winSound.mp3")
            score += 1
            imageOpacities = [0, 0, 0]
            renderKey = UUID()
            
        } else {
            playAudio(resourceName: "loseSound.mp3")
            score -= 1
            imageOpacities = [0, 0, 0]
            renderKey = UUID()


        }
        
        if questionCount == 10 {
            showingResults = true
        } else {
            computerChoice = Int.random(in: 0..<3)
            shouldWin.toggle()
            questionCount += 1
            shuffledData = Array(0..<3).enumerated().map { (index, value) in
                return (originalIndex: index, shuffledValue: value)
            }.shuffled()
            
        }
        
        
    }
    
    func reset () {
        computerChoice = Int.random(in: 0..<3)
        shouldWin = Bool.random()
        questionCount = 0
        score = 0
        shuffledData = Array(0..<3).enumerated().map { (index, value) in
            return (originalIndex: index, shuffledValue: value)
        }.shuffled()
        imageOpacities = [0, 0, 0]
        renderKey = UUID()

    }
    
    func playAudio(resourceName: String, volume: Float = 0.6, loop: Bool = false) {
        if let path = Bundle.main.path(forResource: resourceName, ofType: nil) {
            let url = URL(fileURLWithPath: path)
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.volume = volume
                if loop {
                    audioPlayer.numberOfLoops = -1
                }

                audioPlayer.play()
                if loop {
                    backgroundMusicPlayer = audioPlayer
                } else {
                    player = audioPlayer
                }
            } catch {
                print("No se pudo cargar el archivo de sonido: \(resourceName)")
            }
        }
    }



    
    
}

#Preview {
    ContentView()
}
