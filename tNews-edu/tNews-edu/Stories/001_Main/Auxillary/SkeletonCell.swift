//
//  SkeletonCell.swift
//  tNews-edu
//
//  Created by Nikita Terin on 01.07.2025.
//

import UIKit

final class SkeletonCell: UICollectionViewCell {

    private let skeleton = UIView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        skeleton.layer.removeAllAnimations()
    }

    func configure(with height: CGFloat) {
        NSLayoutConstraint.activate([
            skeleton.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    private func commonInit() {
        contentView.addSubview(skeleton)
        skeleton.backgroundColor = .systemFill

        skeleton.pinEdgesToSuperview()

        skeleton.layer.cornerRadius = 24
        skeleton.layer.cornerCurve = .continuous
        skeleton.layer.masksToBounds = true
    }
}
