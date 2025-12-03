import SwiftUI

struct ContentView: View {
    let bgColor = Color(red: 11/255, green: 90/255, blue: 133/255)

    var body: some View {
        NavigationStack {
            ZStack {
                bgColor.ignoresSafeArea()

                VStack {
                    countdownTimer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("Logo")
                        .resizable()
                        .frame(width: 153, height: 102)
                        .padding(.top, 40)   // keep this fine
                }
            }
            .toolbarBackground(bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
