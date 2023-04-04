import SwiftUI

struct NativeLanguageView: View {
    @State private var selectedNativeLanguage = 0
    @Binding var isNativeLanguageSet: Bool
    
    let languages = ["English", "German", "French"]
    
    var body: some View {
        VStack {
            Text("Select your native language")
                .font(.largeTitle)
                .padding()
            
            Picker(selection: $selectedNativeLanguage, label: Text("Native Language")) {
                ForEach(0 ..< languages.count, id: \.self) {
                    Text(self.languages[$0])
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 200)
            .padding()
            
            Button(action: {
                UserDefaults.standard.set(languages[selectedNativeLanguage], forKey: "nativeLanguage")
                isNativeLanguageSet = true
            }) {
                Text("Continue")
                    .font(.title)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding([.leading, .trailing], 40)
            }
        }
    }
}

struct NativeLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        NativeLanguageView(isNativeLanguageSet: .constant(false))
    }
}
