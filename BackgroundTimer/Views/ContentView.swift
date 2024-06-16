//
//  ContentView.swift
//  BackgroundTimer
//
//  Created by Dmitry Kononchuk on 13.06.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Property Wrappers
    
    @StateObject private var backgroundTimer = BackgroundTimer()
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 24) {
            Text("\(backgroundTimer.timeRemaining)")
                .font(.title)
                .foregroundStyle(.red)
            
            Button("Stop") {
                backgroundTimer.stop()
            }
            
            Button("Resume") {
                backgroundTimer.resume()
            }
            
            Button("Restart") {
                startTimer()
            }
        }
        .onAppear {
            startTimer()
        }
    }
    
    // MARK: - Private Methods
    
    private func startTimer() {
        backgroundTimer.start(with: 30)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
