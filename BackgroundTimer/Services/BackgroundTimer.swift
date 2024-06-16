//
//  BackgroundTimer.swift
//  BackgroundTimer
//
//  Created by Dmitry Kononchuk on 13.06.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import Foundation
import Combine

final class BackgroundTimer: ObservableObject {
    // MARK: - Property Wrappers
    
    @Published private(set) var timeRemaining: UInt = .zero
    
    // MARK: - Private Properties
    
    private var backgroundDate: Date?
    private var differenceSeconds: UInt = .zero
    private var timer: Timer?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    init() {
        Publisher.didEnterBackgroundNotification
            .sink { [weak self] _ in
                self?.setBackgroundDate(with: Date())
            }
            .store(in: &cancellables)
        
        Publisher.didBecomeActiveNotification
            .sink { [weak self] _ in
                self?.setDifferenceSeconds()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Deinitializers
    
    deinit {
        stop()
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Public Methods
    
    func start(with seconds: UInt) {
        guard seconds > .zero else { return }
        
        timer?.invalidate()
        timeRemaining = seconds
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.timer = Timer(timeInterval: 1, repeats: true) { _ in
                self?.updateRemainingTime()
            }
            
            if let timer = self?.timer {
                let runLoop = RunLoop.current
                runLoop.add(timer, forMode: .common)
                runLoop.run()
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func resume() {
        guard timer == nil else { return }
        start(with: timeRemaining)
    }
    
    // MARK: - Private Methods
    
    private func updateRemainingTime() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  self.timeRemaining > .zero,
                  self.backgroundDate == nil
            else { return }
            
            if self.differenceSeconds != .zero {
                self.timeRemaining -= self.differenceSeconds
                self.differenceSeconds = .zero
            } else {
                self.timeRemaining -= 1
            }
            
            if self.timeRemaining == .zero {
                self.stop()
            }
        }
    }
    
    private func setDifferenceSeconds() {
        guard let backgroundDate = backgroundDate, timer != nil else { return }
        
        let differenceSeconds = Calendar.current.dateComponents(
            [.second],
            from: backgroundDate,
            to: Date()
        ).second ?? .zero
        
        if timeRemaining > differenceSeconds {
            self.differenceSeconds = UInt(differenceSeconds)
        } else {
            timeRemaining = .zero
        }
        
        setBackgroundDate(with: nil)
    }
    
    private func setBackgroundDate(with date: Date?) {
        guard timer != nil else { return }
        backgroundDate = date
    }
}
