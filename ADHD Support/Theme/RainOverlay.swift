//
//  RainOverlay.swift
//  ADHD Support
//
//  Created by Peter McMichael on 12/16/25.
//

import SwiftUI
import UIKit


struct RainOverlay: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear


        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -10)
        emitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)


        let cell = CAEmitterCell()
        cell.birthRate = 220
        cell.lifetime = 4.0
        cell.velocity = 520
        cell.velocityRange = 140
        cell.yAcceleration = 300
        cell.emissionLongitude = .pi // downward
        cell.emissionRange = .pi / 32
        cell.scale = 0.12
        cell.scaleRange = 0.06
        cell.alphaSpeed = -0.15


        // Preferred: add a small "Raindrop.png" asset and use it:
        if let img = UIImage(named: "Raindrop")?.cgImage {
            cell.contents = img
        } else {
            // Fallback: use an SF Symbol rendered to an image
            let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
            let symbol = UIImage(systemName: "drop.fill", withConfiguration: config)?
                .withTintColor(.white, renderingMode: .alwaysOriginal)
            cell.contents = symbol?.cgImage
        }


        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)


        return view
    }


    func updateUIView(_ uiView: UIView, context: Context) { }
}


