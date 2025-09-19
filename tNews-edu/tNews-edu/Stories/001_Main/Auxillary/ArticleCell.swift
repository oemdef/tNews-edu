//
//  MainCell.swift
//  tNews-edu
//
//  Created by Nikita Terin on 01.07.2025.
//

import UIKit

final class ArticleCell: UICollectionViewCell {

    private(set) var configuration: MainItemViewModel?

    // MARK: - UI

    private let cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = .systemFill
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()

    private let imageView: ImageView = {
        let imageView = ImageView()
        imageView.backgroundColor = .secondarySystemFill
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorLabel
    }()

    private let publishedAtLabel: UILabel = {
        let publishedAtLabel = UILabel()
        publishedAtLabel.textAlignment = .right
        publishedAtLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        publishedAtLabel.translatesAutoresizingMaskIntoConstraints = false
        return publishedAtLabel
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 4
        titleLabel.font = UIFont.systemFont(ofSize: 14.5, weight: .heavy)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private let sourceLabel: UILabel = {
        let sourceLabel = UILabel()
        sourceLabel.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        return sourceLabel
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        configuration = nil

        authorLabel.text = ""
        publishedAtLabel.text = ""
        titleLabel.text = ""
        sourceLabel.text = ""
    }

    func configure(with configuration: MainItemViewModel) {
        guard self.configuration != configuration else { return }
        self.configuration = configuration

        sourceLabel.text = configuration.sourceName
        titleLabel.text = configuration.title
        authorLabel.text = configuration.author
        publishedAtLabel.text = configuration.publishedAt

        imageView.apply(configuration.image)
    }

    // MARK: - Private

    private func commonInit() {
        setupHierarchy()
        setupConstraints()
    }

    private func setupHierarchy() {
        contentView.addSubview(cardView)
        cardView.addSubview(imageView)
        cardView.addSubview(sourceLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(authorLabel)
        cardView.addSubview(publishedAtLabel)
    }

    private func setupConstraints() {
        cardView.pinEdgesToSuperview()

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 130)
        ])

        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        NSLayoutConstraint.activate([
            sourceLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            sourceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            sourceLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
            authorLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16)
        ])

        NSLayoutConstraint.activate([
            publishedAtLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            publishedAtLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
            publishedAtLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            authorLabel.trailingAnchor.constraint(equalTo: publishedAtLabel.leadingAnchor, constant: -16)
        ])

        authorLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        cardView.layer.cornerRadius = 24
        cardView.layer.cornerCurve = .continuous
        cardView.layer.masksToBounds = true
    }
}
