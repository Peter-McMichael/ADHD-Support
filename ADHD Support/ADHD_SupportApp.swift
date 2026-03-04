//
//  ADHD_SupportApp.swift
//  ADHD Support
//
//  Created by Peter McMichael on 11/18/25.
//

import SwiftUI

@main
struct ADHD_SupportApp: App {
    @StateObject private var todoStorage = TodoStorage()
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        
        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(todoStorage)
        }
    }
}

