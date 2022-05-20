//
//  HapticsManager.swift
//  Fakebakka
//
//  Created by Uchiyama Hiiro on 2022/03/21.
//

import Foundation
import UIKit

class HapticsManager {
    // FIREBASE SETIUP
    static let shared = HapticsManager()
    // INIT METHODS
    private init() {}
    // Selection
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    // Notification
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
