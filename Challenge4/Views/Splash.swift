import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        VStack {
            if isActive {
                ContentView()
            } else {
                VStack {
                    Text("DesignTrack")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .scaleEffect(1.5)
                }
                .onAppear {
                    // Simula um tempo de carregamento
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            self.isActive = true
                        }
                        
                    }
                }
            }
        }
    }
}




