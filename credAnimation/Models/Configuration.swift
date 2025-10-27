//
//  Configuration.swift
//  credAnimation
//
//  Created by Darshan Dodia on 17/07/25.
//

import SwiftUI

/// A nested struct to hold all tunable constants for easy modification.
struct Configuration {
    static let stackedYOffset: CGFloat = 12
    static let cardViewHeight: CGFloat = 190
    static let listSpacing: CGFloat = 15
    static let stackedScaleReduction: CGFloat = 0.05
    static let springAnimation = Animation.spring(response: 0.4, dampingFraction: 0.7)

    // Delay before showing full list
    static let transitionDelay: Double = 0.35
}
