//
//  Theme.swift
//  ADHD Support
//
//  Created by Peter McMichael on 12/16/25.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable, Equatable {
    case classic
    case rain
    case field
    case underwater
    case space
    
    
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .classic: return "Classic"
        case .rain: return "Rain"
        case .field: return "Field"
        case .underwater: return "Underwater"
        case .space: return "Space"
        }
    }
    
    var chromeColor: Color {
           switch self {
           case .classic:
               return Color(red: 11/255, green: 90/255, blue: 133/255)
           case .rain:
               return Color(red: 8/255, green: 18/255, blue: 32/255)
           case .field:
               return Color(red: 10/255, green: 60/255, blue: 35/255)
           case .underwater:
               return Color(red: 5/255, green: 20/255, blue: 50/255)
           case .space:
               return Color.black
           }
       }

    
    var background: AnyView {
            switch self {
            case .classic:
                return AnyView(
                    LinearGradient(
                        colors: [Color(red: 11/255, green: 90/255, blue: 133/255)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )


            case .rain:
                return AnyView(
                    LinearGradient(
                        colors: [
                            Color(red: 8/255, green: 18/255, blue: 32/255),
                            Color(red: 16/255, green: 36/255, blue: 64/255)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )



            
        case .field:
            return AnyView(
                GrassyField()
                    .ignoresSafeArea()
            )
            case .underwater:
                return AnyView(
                    UnderwaterWaveBackground()
                        .ignoresSafeArea()
                )
            case .space:
                return AnyView(
                    Space_T()
                        .ignoresSafeArea()
                )
            
        }
    }
    
    var focusColor: Color {
        switch self {
        case .classic: return .green
        case .rain: return Color(red: 140/255, green: 210/255, blue: 255/255) //icy blue
        case .field: return .green
        case .underwater: return Color(red: 9/255, green: 154/255, blue: 237/255)
        case .space: return Color(red: 120/255, green: 180/255, blue: 255/255)
        }
    }
    
    var breakColor: Color {
        switch self {
        case .classic: return .blue
        case .rain: return Color(red: 170/255, green: 255/255, blue: 220/255)
        case .field: return .green
        case .underwater: return Color(red: 17/255, green: 212/255, blue: 205/255) //aquamarine
        case .space: return Color(red: 180/255, green: 140/255, blue: 255/255)
        }
    }
    
    var showsRainOverlay: Bool {
        switch self {
        case .classic: return false
        case .rain: return true
        case .field: return false
        case .underwater: return false
        case .space: return false
        }
    }
    
    struct AmbientSound {
        let name: String
        let ext: String
    }
    
    var ambientSound: AmbientSound? {
        switch self {
        case.classic:
            return nil
        case.rain:
            return AmbientSound(name: "RainLoop02", ext: "mp3")
        case.field:
            return nil
        case .underwater:
            return AmbientSound(name: "UnderwaterLoop", ext: "mp3")
        case .space:
            return AmbientSound(name: "SpaceHum", ext: "mp3")
        }
    }
    struct UnderwaterWaveBackground: View {

        var body: some View {
            TimelineView(.animation) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate

                ZStack {

                    //deep ocean gradient
                    LinearGradient(
                        colors: [
                            Color(red: 5/255, green: 20/255, blue: 50/255),
                            Color(red: 0/255, green: 70/255, blue: 95/255),
                            Color(red: 40/255, green: 140/255, blue: 160/255)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    //back wave
                    WaveShape(
                        amplitude: 18,
                        wavelength: 260,
                        phase: t * 0.6
                    )
                    .fill(Color.white.opacity(0.10))
                    .offset(y: -40)

                    //middle wave
                    WaveShape(
                        amplitude: 14,
                        wavelength: 200,
                        phase: t * 0.9
                    )
                    .fill(Color.white.opacity(0.12))
                    .offset(y: -10)

                    //front wave
                    WaveShape(
                        amplitude: 10,
                        wavelength: 150,
                        phase: t * 1.3
                    )
                    .fill(Color.white.opacity(0.16))
                    .offset(y: 20)
                }
            }
        }
    }


    //MARK: - wave shape helper
    struct WaveShape: Shape {

        var amplitude: CGFloat
        var wavelength: CGFloat
        var phase: Double

        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: rect.midY))

            for x in stride(from: 0, through: rect.width, by: 1) {
                let relative = x / wavelength
                let y = rect.midY + sin(relative + phase) * amplitude
                path.addLine(to: CGPoint(x: x, y: y))
            }

            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()

            return path
        }
    }
    
}
