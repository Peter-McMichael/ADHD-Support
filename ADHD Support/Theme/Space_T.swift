//
//  Space_T.swift
//  ADHD Support
//
//  Created by Peter McMichael on 2/7/26.
//

import SwiftUI

//MARK: - Space Background
//dark space gradient + animated drifting stars
struct Space_T: View {
    
    @State private var drift: CGFloat = -200
    
    var body: some View {
        ZStack {
            
            //deep space gradient
            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.05, blue: 0.12),
                    Color(red: 0.01, green: 0.02, blue: 0.06),
                    Color.black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            //star layers (multiple layers = depth)
            StarLayer(count: 70, size: 1.5, speed: 18, drift: drift)
            StarLayer(count: 40, size: 2.2, speed: 26, drift: drift)
            StarLayer(count: 18, size: 3.0, speed: 34, drift: drift)
        }
        .onAppear {
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                drift = 200
            }
        }
    }
}


//MARK: - Star Layer
//reusable moving star group
struct StarLayer: View {
    let count: Int
    let size: CGFloat
    let speed: Double
    let drift: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<count, id: \.self) { _ in
                Star(size: size)
                    .position(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: CGFloat.random(in: 0...geo.size.height)
                    )
                    .offset(x: drift)
                    .animation(
                        .linear(duration: speed)
                        .repeatForever(autoreverses: false),
                        value: drift
                    )
            }
        }
    }
}


//MARK: - Single Star
//tiny glowing + twinkle animation
struct Star: View {
    let size: CGFloat
    @State private var twinkle = false
    
    var body: some View {
        Circle()
            .fill(.white)
            .frame(width: size, height: size)
            .opacity(twinkle ? 1 : 0.3)
            .blur(radius: 0.3)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 0.8...2.2))
                    .repeatForever(autoreverses: true)
                ) {
                    twinkle.toggle()
                }
            }
    }
}
