//
//  MainCellRegistrar.swift
//  tNews-edu
//
//  Created by Nikita Terin on 01.07.2025.
//

import UIKit

final class MainCellRegistrar {
    private typealias ArticleCellRegistration = UICollectionView.CellRegistration<ArticleCell, MainItemViewModel>
    private typealias SkeletonCellRegistration = UICollectionView.CellRegistration<SkeletonCell, CGFloat>

    private var articleCellRegistration: ArticleCellRegistration?
    private var skeletonCellRegistration: SkeletonCellRegistration?

    func setup() {
        articleCellRegistration = ArticleCellRegistration { cell, _, viewModel in
            cell.configure(with: viewModel)
        }

        skeletonCellRegistration = SkeletonCellRegistration { cell, _, height in
            cell.configure(with: height)
        }
    }

    func dequeueCell(
        for item: MainItem,
        collectionView: UICollectionView,
        indexPath: IndexPath
    ) -> UICollectionViewCell? {
        switch item {
        case .skeleton(_, let height):
            guard let skeletonCellRegistration else { return nil }
            return collectionView.dequeueConfiguredReusableCell(
                using: skeletonCellRegistration,
                for: indexPath,
                item: height
            )
        case .active(let viewModel):
            guard let articleCellRegistration else { return nil }
            return collectionView.dequeueConfiguredReusableCell(
                using: articleCellRegistration,
                for: indexPath,
                item: viewModel
            )
        }
    }
}
