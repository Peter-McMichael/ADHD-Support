import SwiftUI


struct GrassyField: View {
    @State private var sway = false


    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: - Sky
                LinearGradient(
                    colors: [
                        Color(red: 0.45, green: 0.75, blue: 0.98),
                        Color(red: 0.75, green: 0.92, blue: 1.00)
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()


               
                // MARK: - Ground (field)
                VStack(spacing: 0) {
                    Spacer()


                    ZStack {
                        // Base grass gradient
                        LinearGradient(
                            colors: [
                                Color(red: 0.20, green: 0.55, blue: 0.20),
                                Color(red: 0.12, green: 0.38, blue: 0.12),
                                Color(red: 0.08, green: 0.24, blue: 0.08)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )


                        // Subtle lighting vignette
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.10),
                                Color.black.opacity(0.25)
                            ],
                            center: .top,
                            startRadius: 30,
                            endRadius: geo.size.width * 0.9
                        )
                        .blendMode(.overlay)


                        // Grass texture (procedural dots/lines)
                        GrassTexture()
                            .opacity(0.25)
                            .blendMode(.overlay)


                        // Animated shimmer (very subtle)
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.0),
                                        Color.white.opacity(0.08),
                                        Color.white.opacity(0.0)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .rotationEffect(.degrees(-12))
                            .offset(x: sway ? geo.size.width * 0.25 : -geo.size.width * 0.25)
                            .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: sway)
                            .blendMode(.softLight)
                    }
                    .frame(height: geo.size.height * 0.55)
                }
                .ignoresSafeArea()
            }
            .onAppear { sway = true }
        }
    }
}


// MARK: - Procedural grass texture
private struct GrassTexture: View {
    var body: some View {
        Canvas { context, size in
            // Tiny “blades” and dots to break up flat color
            let bladeCount = Int(size.width * 0.7)   // scale with width
            let dotCount = Int(size.width * 1.2)


            // Blades
            for i in 0..<bladeCount {
                let x = CGFloat(i) / CGFloat(max(bladeCount - 1, 1)) * size.width
                let y = size.height * (0.15 + CGFloat((i * 37) % 70) / 100.0) // pseudo-random band
                let height = 10 + CGFloat((i * 53) % 18)


                var path = Path()
                path.move(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x + 1, y: y - height))


                context.stroke(
                    path,
                    with: .color(Color.white.opacity(0.20)),
                    lineWidth: 1
                )
            }


            // Dots (texture/noise)
            for i in 0..<dotCount {
                let x = CGFloat((i * 73) % 997) / 997 * size.width
                let y = CGFloat((i * 97) % 991) / 991 * size.height
                let r = CGFloat(1 + (i % 2))


                let rect = CGRect(x: x, y: y, width: r, height: r)
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(Color.black.opacity(0.10))
                )
            }
        }
    }
}




