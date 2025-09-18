//
//  UIView+pinEdgesToSuperview.swift
//  tNews-edu
//
//  Created by Nikita Terin on 30.07.2025.
//

import UIKit

extension UIView {
    func pinEdgesToSuperview(insets: NSDirectionalEdgeInsets = .zero) {
        guard let superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.leading),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.trailing),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }
}
