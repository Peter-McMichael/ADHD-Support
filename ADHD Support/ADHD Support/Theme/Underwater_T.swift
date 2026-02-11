//
//  Underwater_T.swift
//  ADHD Support
//
//  underwater theme definition + animated wave background
//  kept self-contained so it is easy to plug into views
//

import SwiftUI


//MARK: - theme model
//container for UI colors + background styles
struct Underwater_T {

    //animated background view instead of plain gradient
    let background: AnyView

    //task card / panel background color
    let cardBackground: Color

    //main highlight color for buttons + checkmarks
    let accent: Color

    //primary readable text color
    let textPrimary: Color

    //secondary text color
    let textSecondary: Color
}


//MARK: - built in themes
extension Underwater_T {

    //MARK: Underwater theme
    static let underwater = Underwater_T(

        //animated wave background
        background: AnyView(
            WaveBackground()
                .ignoresSafeArea()
        ),

        //cards look like darker underwater glass
        cardBackground: Color(red: 0.00, green: 0.22, blue: 0.30),

        //bright aqua accent pops against dark blue
        accent: Color(red: 0.20, green: 0.85, blue: 0.80),

        //white text reads best on dark backgrounds
        textPrimary: .white,

        //slightly dimmed white for less important text
        textSecondary: Color.white.opacity(0.75)
    )
}


//MARK: - animated underwater wave background
//draws layered moving sine waves
//lightweight + loops automatically
struct WaveBackground: View {

    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate

            ZStack {

                //deep ocean gradient base
                LinearGradient(
                    colors: [
                        Color(red: 5/255, green: 20/255, blue: 50/255),
                        Color(red: 0/255, green: 70/255, blue: 95/255),
                        Color(red: 40/255, green: 140/255, blue: 160/255)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                //back slow wave
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

                //front faster wave
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


//MARK: - sine wave shape helper
//used by WaveBackground to draw waves
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

        //close shape so fill works
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}
