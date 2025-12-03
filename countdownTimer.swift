//
//  Timer.swift
//  ADHD Support
//
//  Created by Peter McMichael on 11/18/25.
//
import SwiftUI

struct countdownTimer: View {
    @State private var timerActive = false
    @State private var focusMinutes: Int = 25
    @State private var breakMinutes: Int = 5
    @State private var sessionType: SessionType = .focusTime
 
    
    enum SessionType {
        case focusTime
        case breakTime
        
        var displayName: String {
            switch self {
            case .focusTime: return ("Focus")
            case .breakTime: return ("Break")
                
            }
        }
        var textColor: String {
            switch self {
                case .focusTime: return ("Green")
                case .breakTime: return ("Blue")
            }
        }
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeRemaining: Int = 25*60
    var body: some View {
        
        VStack {
            Text("\(sessionType.displayName) Session")
                .font(.title2)
                .fontWeight(.semibold)
            Text(formattedTime(seconds: timeRemaining))
            
            HStack {
                Button(action: startOrPause){
                    Text(timerActive ? "Pause" : "Start")
                }
                Button(action: resetCurrentSession){
                    Text("Reset")
         
                }

                
            }
            HStack{
                VStack {
                    Text("Focus (min)")
                    Stepper(value: $focusMinutes, in: 1...60, step: 1) {
                        Text("\(focusMinutes)")
                        
                    }
                    .disabled(timerActive)
                }
                VStack {
                    Text("Break (min)")
                    Stepper(value: $breakMinutes, in: 1...10, step: 1) {
                        Text("\(breakMinutes)")
                    }
                    .disabled(timerActive)
                }
            }
        }
        .onReceive(timer) { _ in
            guard timerActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerActive = false // Stop timer when it reaches 0
                toggleSession()
            }
        }
        .onChange(of: focusMinutes) { updateFocus in
            guard !timerActive, sessionType == .focusTime else { return }
            timeRemaining = updateFocus * 60
        }
        .onChange(of: breakMinutes) { updateBreak in
            guard !timerActive, sessionType == .breakTime else { return }
            timeRemaining = updateBreak * 60
        }
        
    }
    

    func formattedTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    private func resetCurrentSession(){
        switch sessionType {
        case .focusTime:
            timeRemaining = focusMinutes * 60
        case .breakTime:
            timeRemaining = breakMinutes * 60
        }
        timerActive = false
    }
    private func toggleSession() {
        sessionType = (sessionType == .focusTime) ? .breakTime : .focusTime
        resetCurrentSession()
    }
    private func startOrPause() {
        if !timerActive && timeRemaining == 0 {
            resetCurrentSession()
        }
        timerActive.toggle()
    }
}
