//
//  CAAnimation+endlessPulseAnimation.swift
//  tNews-edu
//
//  Created by Nikita Terin on 19.08.2025.
//

import QuartzCore

private enum DefaultValues {
    static let fromValue: CGFloat = 0
    static let toValue: CGFloat = 1
    static let duration: CGFloat = 0.8
    static let repeatCount: Float = .greatestFiniteMagnitude
}

extension CAAnimation {
    static let endlessPulseAnimation: CAAnimation = pulseAnimation(repeatCount: .greatestFiniteMagnitude)

    static func pulseAnimation(
        fromValue: CGFloat = DefaultValues.fromValue,
        toValue: CGFloat = DefaultValues.toValue,
        duration: CGFloat = DefaultValues.duration,
        repeatCount: Float = DefaultValues.repeatCount
    ) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.beginTime = .now
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = false
        return animation
    }
}

extension CFTimeInterval {
    static let now = CACurrentMediaTime()
}
