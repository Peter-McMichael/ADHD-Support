//
//  GrassyField.swift
//  ADHD Support
//
//  Created by Peter McMichael on 12/16/25.
//

import SwiftUI

struct GrassyField: View {
    @State private var animateColor = false
    
    var body: some View {
        VStack {
            Text("Animated Background")
                .font(.title)
                .foregroundColor(.white)
                .padding(50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(animateColor ? Color.blue : Color.green) // Change color based on state
        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateColor) // Animate the change
        .onAppear {
            animateColor.toggle() // Start the animation when the view appears
        }
        .ignoresSafeArea() // Ensure the background fills the whole screen
    }
}
