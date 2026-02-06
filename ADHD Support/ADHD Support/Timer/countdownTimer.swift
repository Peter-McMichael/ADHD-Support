//
//  Timer.swift
//  ADHD Support
//
//  Created by Peter McMichael on 11/18/25.
//



import SwiftUI

struct countdownTimer: View {

    let theme: AppTheme

    @State private var timerActive = false
    @State private var focusMinutes: Int = 25
    @State private var breakMinutes: Int = 5
    @State private var sessionType: SessionType = .focusTime
    @State private var isPressed = false
    @State private var localMute: Bool = false
   
    @AppStorage("vibrateOnSessionEnd") private var vibrateOnSessionEnd: Bool = true
    @AppStorage("soundOnSessionEnd") private var soundOnSessionEnd: Bool = true
    @AppStorage("autoStartNextSession") private var autoStartNextSession: Bool = false
    @AppStorage("AmbientEnabled") private var ambientEnabled: Bool = true

    enum SessionType {
        case focusTime
        case breakTime

        var displayName: String {
            switch self {
            case .focusTime:
                return "Focus"
            case .breakTime:
                return "Break"
            }
        }
    }

    private var sessionColor: Color {
        sessionType == .focusTime ? theme.focusColor : theme.breakColor
    }
    
    private var totalSeconds: Int {
        switch sessionType {
        case .focusTime:
            return max(focusMinutes, 1) * 60
        case .breakTime:
            return max(breakMinutes, 1) * 60
        }
    }
    
    
    private var progress: CGFloat {
        guard totalSeconds > 0 else { return 0 }
        return CGFloat(timeRemaining) / CGFloat(totalSeconds)
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeRemaining: Int = 25 * 60

    var body: some View {
        VStack(spacing: 24) {
            
            
 
                
                ZStack {
                    Circle()
                        .fill(
                            Color(red: 83/255, green: 104/255, blue: 114/255)
                        )
                       
                        .frame(width: 260, height: 260)
                    
                    Circle()
                        .stroke(
                            Color.white.opacity(0.2),
                            style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            sessionColor,
                            style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.2), value: progress)
                    VStack {
                        Text("\(sessionType.displayName) Session")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(sessionColor)
                        
                        Text(formattedTime(seconds: timeRemaining))
                            .foregroundStyle(sessionColor)
                    }
                    
                }
                .scaleEffect(isPressed ? 0.96 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
            
                .frame(width: 260, height: 260)
            
                .contentShape(Circle())
            
                .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
                    isPressed = pressing
                }, perform: {
                    startOrPause()
                })
            
          
    
                
            

            HStack(spacing: 20) {
               

                Button {
                   resetCurrentSession()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundStyle(theme.focusColor)
                }
            }

            VStack(spacing: 16) {
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
                
                if ambientEnabled, theme.ambientSound != nil {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                localMute.toggle()
                                applyAmbience(for: theme)
                            } label: {
                                Image(systemName: localMute ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            }
                            .scaleEffect(isPressed ? 0.96 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
                            .buttonStyle(.plain)
                            .padding(20)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            applyAmbience(for: theme)
        }
        .onDisappear {
            SoundManager.shared.stopAmbience()
        }
        .onReceive(timer) { _ in
            guard timerActive else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerActive = false
                toggleSession()
                giveEndOfSessionFeedback()

                if autoStartNextSession {
                    timerActive = true
                }
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

    private func resetCurrentSession() {
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

    private func giveEndOfSessionFeedback() {
        if vibrateOnSessionEnd {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
        if soundOnSessionEnd {
            SoundManager.shared.playEndOfSessionSound()
        }
    }
    
    private func applyAmbience(for theme: AppTheme) {
        guard ambientEnabled, !localMute, let ambient = theme.ambientSound else {
            SoundManager.shared.stopAmbience()
            return
        }
        
        SoundManager.shared.startAmbience(name: ambient.name, ext: ambient.ext)
        
    }
    
        
}
