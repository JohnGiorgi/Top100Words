import SwiftUI
import AVFoundation

struct LearningView: View {
    let targetLanguage: String
    let nativeLanguage: String
    
    private static let words: [String: String] = [
        "the": "le/la/les",
        "of": "de",
        "and": "et",
        "a": "un/une",
        "to": "à",
        "in": "dans",
        "is": "est",
        "you": "tu/vous",
        "that": "que",
        "it": "il/elle/cela",
        "he": "il",
        "was": "était",
        "for": "pour",
        "on": "sur",
        "are": "sont",
        "as": "comme",
        "with": "avec",
        "his": "son/sa",
        "they": "ils/elles",
        "I": "je",
        "at": "à",
        "be": "être",
        "this": "ceci",
        "have": "avoir",
        "from": "depuis",
        "or": "ou",
        "one": "un",
        "had": "avait",
        "by": "par",
        "word": "mot",
        "not": "pas",
        "what": "quoi",
        "all": "tout",
        "when": "quand",
        "your": "ton/ta",
        "can": "peut",
        "said": "dit",
        "use": "utiliser",
        "an": "un/une",
        "each": "chaque",
        "which": "lequel/laquelle",
        "do": "faire",
        "how": "comment",
        "will": "volonté",
        "up": "en haut",
        "other": "autre",
        "about": "sur",
        "out": "dehors",
        "many": "beaucoup de",
        "then": "ensuite",
        "them": "les",
        "these": "ces",
        "so": "donc",
        "there": "là",
        "her": "sa",
        "would": "voudrais",
        "him": "lui",
        "into": "dans",
        "time": "temps",
        "has": "a",
        "like": "aimer",
        "two": "deux",
        "more": "plus",
        "write": "écrire",
        "go": "aller",
        "number": "nombre",
        "no": "non",
        "way": "façon",
        "could": "pourrait",
        "people": "gens",
        "its": "son/sa",
        "now": "maintenant",
        "find": "trouver",
        "long": "long",
        "down": "vers le bas",
        "day": "jour",
        "did": "a fait",
        "get": "obtenir",
        "come": "venir",
        "made": "fait",
        "part": "partie"
    ]

    @State private var words: [String: String] = LearningView.words
    @State private var wordMistakes: [String: Int] = [:]
    @State private var currentWord: String = ""
    @State private var choices: [String] = {
        let randomValues = Array(LearningView.words.values.shuffled().prefix(4))
        return randomValues
    }()
    @State private var remainingGuesses: Int = 3
    @State private var isShowingAnswer: Bool = false
    @State private var timeRemaining: Int = 60
    @State private var timer: Timer? = nil
    @State private var isCorrect: [Bool] = Array(repeating: false, count: 4)
    @State private var isIncorrect: [Bool] = Array(repeating: false, count: 4)

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func generateChoices(for currentWord: String) {
        choices = [words[currentWord]!]
        while choices.count < 4 {
            if let choice = words.values.randomElement(), !choices.contains(choice) {
                choices.append(choice)
            }
        }
        choices.shuffle()
    }

    private func selectNextWord() {
        let mistakeFrequency: [String]
        if currentWord.isEmpty {
            mistakeFrequency = []
        } else {
            mistakeFrequency = Array(repeating: currentWord, count: (wordMistakes[currentWord] ?? 0) + 1)
        }
        
        let wordPool = words.keys + mistakeFrequency
        if let word = wordPool.randomElement() {
            currentWord = word
        } else {
            currentWord = words.keys.randomElement()!
        }

        // Add this line to call generateChoices after setting the currentWord
        generateChoices(for: currentWord)
    }

    // Add this function to play a sound
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "correct", withExtension: "wav") else { return }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }

    private func checkAnswer(_ answer: String) {
        if answer == words[currentWord] {
            playSound() // Play the sound when the answer is correct
            isCorrect = choices.indices.map { choices[$0] == words[currentWord] }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isCorrect = Array(repeating: false, count: 4)
                selectNextWord()
                generateChoices(for: currentWord)
                remainingGuesses = 3
                isShowingAnswer = false
            }
        } else {
            remainingGuesses -= 1
            let incorrectIndex = choices.firstIndex(of: answer) ?? -1
            if incorrectIndex >= 0 {
                isIncorrect[incorrectIndex] = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isIncorrect[incorrectIndex] = false
                }
            }
            if remainingGuesses == 0 {
                isShowingAnswer = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    selectNextWord()
                    generateChoices(for: currentWord)
                    remainingGuesses = 3
                    isShowingAnswer = false
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Translate the following word:")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)

            Text(currentWord)
                .font(.system(size: 40, weight: .bold))
                .padding(.bottom)

            VStack {
                ForEach(0..<2) { rowIndex in
                    HStack {
                        ForEach(0..<2) { colIndex in
                            let index = rowIndex * 2 + colIndex
                            Button(action: {
                                if !isShowingAnswer && remainingGuesses > 0 {
                                    checkAnswer(choices[index])
                                }
                            }) {
                                Text(choices[index])
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isCorrect[index] ? Color.green : (isIncorrect[index] ? Color.red : Color.primary.opacity(0.1)))
                                    .foregroundColor(.primary)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    .padding(.bottom, 10)
                }
            }

            Text("Remaining guesses: \(remainingGuesses)")
                .font(.footnote)
                .padding(.top)

            Text("Time remaining: \(timeRemaining)s")
                .font(.footnote)
                .padding(.top)
                .onAppear {
                    startTimer()
                    DispatchQueue.main.async {
                        selectNextWord() // generateChoices will be called inside selectNextWord
                    }
                }
        }
        .padding()
    }
}

struct LearningView_Previews: PreviewProvider {
    static var previews: some View {
        LearningView(targetLanguage: "English", nativeLanguage: "French")
            .preferredColorScheme(.light)
        LearningView(targetLanguage: "English", nativeLanguage: "French")
            .preferredColorScheme(.dark)
    }
}
