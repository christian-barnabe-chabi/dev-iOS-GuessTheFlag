//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Christian on 12/16/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var scoreTitle = ""
    @State private var showScore = false
    @State private var rightAnswersCount = 0
    @State private var iteration = 0
    @State private var showFinalScoreAlert = false
    
    private let maxIterations = 10

    private var showNextQuestion: Bool { iteration < maxIterations }

    private var finalScore: Int { rightAnswersCount * 10 }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.25),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
                .init(color: Color(red: 0.12, green: 0.5, blue: 0.36), location: 0.9),
            ], center: .bottom, startRadius: 200, endRadius: 700)
            .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .foregroundStyle(.white)
                    .font(.largeTitle.bold())
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.bold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagWasTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Correct: \(rightAnswersCount) out of \(iteration)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showScore) {
            if (showNextQuestion) {
                Button("Continue", action: askAgain)
            } else {
                Button("See final Score") {
                    showFinalScoreAlert = true
                }
            }
        } message: {
            Text("Your current score is \(finalScore)")
        }
        .alert("Your final score is \(finalScore)", isPresented: $showFinalScoreAlert) {
            Button("Restart") {
                iteration = 0
                rightAnswersCount = 0
            }
        } message: {
            Text("You've answered \(rightAnswersCount) out of \(maxIterations) questions")
        }
    }
    
    func flagWasTapped(_ number: Int) {
        if (number == correctAnswer) {
            rightAnswersCount += 1
        }
        
        scoreTitle = number == correctAnswer
        ? "You got it!"
        : "Wrong! That’s the flag of \(countries[number])"
        
        showScore = true
        iteration += 1
    }
    
    func askAgain() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
