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
                    Text("Welcome to 💯 Words")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 32)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 48/255, green: 47/255, blue: 47/255))
                        .opacity(0.9)
                    
                    Text("This app will help you learn the _top 100 most frequently used words_ in your chosen language, _as quickly as possible_.")
                        .font(.headline)
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                        .opacity(0.8)
                    
                    Text("Each session is `60` seconds. You are given `2` seconds per word. If you fail to answer in `3` seconds or answer incorrectly, a new word will be shown. Words you don't recongize will be served more often, following the principles of _spaced repetition_.")
                        .font(.headline)
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(red: 64/255, green: 64/255, blue: 64/255))
                        .opacity(0.8)
                    
                    Spacer()
                    
                    // Filter out native language from the languages array
                    let filteredLanguages = languages.filter { $0 != UserDefaults.standard.string(forKey: "nativeLanguage") }
                    Picker(selection: $selectedLanguage, label: Text("")) {
                        ForEach(0 ..< filteredLanguages.count, id: \.self) {
                            Text(filteredLanguages[$0])
                                .font(.headline)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 200)
                    
                    NavigationLink(destination: LearningView(targetLanguage: filteredLanguages[selectedLanguage], nativeLanguage: UserDefaults.standard.string(forKey: "nativeLanguage")!)) {
                        Text("Start Learning \(filteredLanguages[selectedLanguage])")
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
