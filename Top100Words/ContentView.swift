import SwiftUI

struct ContentView: View {
    @State private var selectedLanguage = 0
    @State private var isNativeLanguageSet: Bool
    
    let languages = ["English", "German", "French"]
    
    init() {
        if let _ = UserDefaults.standard.string(forKey: "nativeLanguage") {
            _isNativeLanguageSet = State(initialValue: true)
        } else {
            _isNativeLanguageSet = State(initialValue: false)
        }
    }
    
    var body: some View {
        if isNativeLanguageSet {
            NavigationView {
                VStack(spacing: 16) {
                    Text("Welcome to Language Learner")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 32)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 48/255, green: 47/255, blue: 47/255))
                        .opacity(0.9)
                    
                    Text("This app will help you learn the top 100 most frequently used words in your chosen language as quickly as possible. To get started, select the language you want to learn.")
                        .font(.headline)
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                        .opacity(0.8)
                    
                    Spacer()
                    
                    Picker(selection: $selectedLanguage, label: Text("")) {
                        ForEach(0 ..< languages.count, id: \.self) {
                            Text(self.languages[$0])
                                .font(.headline)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 200)
                    
                    NavigationLink(destination: LearningView(targetLanguage: languages[selectedLanguage], nativeLanguage: UserDefaults.standard.string(forKey: "nativeLanguage")!)) {
                        Text("Start Learning \(languages[selectedLanguage])")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 32)
                    }
                }
            }
        }
        else {
            NativeLanguageView(isNativeLanguageSet: $isNativeLanguageSet)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
