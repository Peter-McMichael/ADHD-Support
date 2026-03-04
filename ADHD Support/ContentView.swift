import SwiftUI

struct ContentView: View {
    @AppStorage("appTheme") private var appThemeRaw: String = AppTheme.classic.rawValue
    @State private var showSettings = false

    private var theme: AppTheme { AppTheme(rawValue: appThemeRaw) ?? .classic }

    var body: some View {
        TabView {
            NavigationStack {
                TodoListView(theme: theme)
                    .navigationTitle("To Do")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button { showSettings = true } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                    }
                    .toolbarBackground(theme.chromeColor, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .tint(.white)
            }
            .tabItem { Label("To Do", systemImage: "checklist") }

            TimerTab(theme: theme, showSettings: $showSettings)
                .tabItem { Label("Timer", systemImage: "timer") }
        }
        .toolbarBackground(theme.chromeColor, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
        .tint(.white)
        .sheet(isPresented: $showSettings) {
            NavigationStack { TimerSettings() }
        }
    }
}

private struct TimerTab: View {
    let theme: AppTheme
    @Binding var showSettings: Bool

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {
                theme.background.ignoresSafeArea()

                if theme.showsRainOverlay {
                    RainOverlay()
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }

                countdownTimer(theme: theme)
                    .padding(.top, 10)

                Button { showSettings = true } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(.white.opacity(0.14))
                }
                .padding(.trailing, 18)
                .padding(.top, geo.safeAreaInsets.top + 10)
            }
        }
    }
}
