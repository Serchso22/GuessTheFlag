//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jorge Sergio Islas Ramos on 20/07/23.
//

import SwiftUI

struct ProminentTitle: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View{
        Text(text)
            .font(.largeTitle)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
// extension View {
//    func largeTitle(with text: String) -> some View{
//        modifier(ProminentTitle(text: text))
//    }
//}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var resetGame = false
    @State private var selectedFlag = -1
    @State private var scoreTitle = ""
    @State private var resetMessage = ""
    @State private var remainingGames = 8
    @State private var score = 0
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var animationAmount = 0.0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    
    
    struct FlagImage: View{
        var imageName: String
        
        var body: some View{
            Image(imageName)
            .renderingMode(.original)
            .cornerRadius(20)
        }
    }
    
    var body: some View {
        ZStack{
            AngularGradient(gradient: Gradient(colors: [.black,.red]), center: .topTrailing) .ignoresSafeArea()
            
            VStack{
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle)
                    .italic()
                    .bold()
                    .foregroundStyle(.gray)
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.black)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundColor(.orange)
                            .font(.largeTitle.weight(.semibold).italic())
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                                flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                        //Day 34 Challenge
                        .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                        .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.75)
                        .animation(.default, value: selectedFlag)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundColor(.gray)
                
                Text("Remaining attempts: \(remainingGames)")
                    .font(.title.bold())
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        }
        
        .alert(resetMessage, isPresented: $resetGame){
            Button("Restart", action: reset)
        } message: {
            Text("Your final score is: \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        
        selectedFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            animationAmount += 360
        } else {
            animationAmount += 360
            scoreTitle = "Wrong, that's the flag of \(countries[number])"
        }
        
        if remainingGames == 1 {
            resetGame = true
            resetMessage = "Start again?"
        } else {
            remainingGames -= 1
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
    }
    
    func reset() {
        score = 0
        remainingGames = 8
        showingScore = false
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
