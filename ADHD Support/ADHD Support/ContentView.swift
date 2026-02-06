import SwiftUI

struct ContentView: View {
    @AppStorage("appTheme") private var appThemeRaw: String = AppTheme.classic.rawValue
    @StateObject private var todoStore = TodoStorage()
    let bgColor = Color(red: 11/255, green: 90/255, blue: 133/255)

    private var theme: AppTheme { AppTheme(rawValue: appThemeRaw) ?? .classic}
    
    var body: some View {
        NavigationStack {
            ZStack {
                theme.background.ignoresSafeArea()
                
                if theme.showsRainOverlay {
                    RainOverlay()
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }

                VStack {
                    countdownTimer(theme: theme)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 153, height: 90)
                        .padding(.leading, 2)   // keep this fine
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        TimerSettings()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.white)
                        
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        MLTestView()
                    } label: {
                        Image(systemName: "brain")
                            .foregroundStyle(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        TodoListView(theme: theme)
                    } label: {
                        Image(systemName: "checklist")
                            .foregroundStyle(.white)
                    }
                }

                
            }
            .toolbarBackground(bgColor, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            
        }
        .environmentObject(todoStore)
    }
}
