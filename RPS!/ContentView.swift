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
    

    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Si tu oponente ha sacado...")
            
            Image(moves[computerChoice])
                .resizable()
                   .scaledToFit()  // Asegura que la imagen mantenga su relación de aspecto original
                   .frame(width: 140)  // Estableces el width que quieres
            
            if shouldWin {
                Text ("¿Con qué ganas?")
                    .foregroundColor(.green)
                    .font(.title)
            } else {
                Text ("¿Con qué pierdes?")
                    .foregroundColor(.red)
                    .font(.title)
            }
            
            
            HStack {
                ForEach(0..<3) {number in
                    Button {
                        play(choice: number)
                    } label: {
                        Image(moves[number])
                            .resizable()
                               .scaledToFit()  // Asegura que la imagen mantenga su relación de aspecto original
                               .frame(width: 80)  // Estableces el width que quieres
                    }
                }
            }
            
            Spacer()

            Text("Tu puntuación es: \(score)")
                .font(.subheadline)
            Spacer()
        }
        .onAppear {
            playAudio(resourceName: "backgroundMusic.mp3", volume: 0.1, loop: true)
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
            score += 1
            playAudio(resourceName: "winSound.mp3")
        } else {
            score -= 1
            playAudio(resourceName: "loseSound.mp3")

        }
        
        if questionCount == 10 {
            showingResults = true
        } else {
            computerChoice = Int.random(in: 0..<3)
            shouldWin.toggle()
            questionCount += 1
        }
        
        
    }
    
    func reset () {
        computerChoice = Int.random(in: 0..<3)
        shouldWin = Bool.random()
        questionCount = 0
        score = 0
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
