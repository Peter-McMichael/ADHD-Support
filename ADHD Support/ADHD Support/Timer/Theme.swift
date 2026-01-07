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
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .classic: return "Classic"
        case .rain: return "Rain"
        case .field: return "Field"
        }
    }
    
    var background: LinearGradient {
        switch self {
        case .classic:
            //matches the original bgColor.
            return LinearGradient(colors: [ Color(red: 11/255, green: 90/255, blue: 133/255)], startPoint: .top,
                                  endPoint: .bottom
            )
        case .rain:
            //matches the original bgColor.
            return LinearGradient(colors: [
                Color(red: 8/255, green: 18/255, blue: 32/255),
                Color(red: 16/255, green: 36/255, blue: 64/255)
            ],
                                  startPoint: .top,
                                  endPoint: .bottom
            )
            
        case .field:
            return LinearGradient(colors: [
                Color(red: 8/255, green: 18/255, blue: 32/255),
                Color(red: 16/255, green: 36/255, blue: 64/255)
                
            ],
                                  startPoint: .top,
                                  endPoint: .bottom
            )
            
        }
    }
    
    var focusColor: Color {
        switch self {
        case .classic: return .green
        case .rain: return Color(red: 140/255, green: 210/255, blue: 255/255) //icy blue
        case .field: return .green
        }
    }
    
    var breakColor: Color {
        switch self {
        case .classic: return .blue
        case .rain: return Color(red: 170/255, green: 255/255, blue: 220/255)
        case .field: return .green
        }
    }
    
    var showsRainOverlay: Bool {
        switch self {
        case .classic: return false
        case .rain: return true
        case .field: return false
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
        }
    }
    
}
