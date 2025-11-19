//
//  Timer.swift
//  ADHD Support
//
//  Created by Peter McMichael on 11/18/25.
//
import SwiftUI

struct Timer: View {
    @State private var timeRemaining = 600 // 10 minutes in seconds
    @State private var timerActive = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text(formattedTime(seconds: timeRemaining))

            HStack {
                Button(action: {
                    timerActive.toggle()
                }) {
                    Text(timerActive ? "Pause" : "Start")
                }


                Button(action: {
                    timeRemaining = 600 // Reset to 10 minutes
                    timerActive = false
                }) {
                    Text("Reset")
                }
            }
        }
        .onReceive(timer) { _ in
            guard timerActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerActive = false // Stop timer when it reaches 0
            }
        }
    }

    func formattedTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
