//
//  Publisher.swift
//  BackgroundTimer
//
//  Created by Dmitry Kononchuk on 14.06.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import UIKit

final class Publisher {
    // MARK: - Public Properties
    
    static let didEnterBackgroundNotification = NotificationCenter.default
        .publisher(for: UIApplication.didEnterBackgroundNotification)
    
    static let didBecomeActiveNotification = NotificationCenter.default
        .publisher(for: UIApplication.didBecomeActiveNotification)
}
