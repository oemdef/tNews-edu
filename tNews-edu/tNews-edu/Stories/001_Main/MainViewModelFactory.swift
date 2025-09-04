//
//  MainViewModelFactory.swift
//  tNews-edu
//
//  Created by Nikita Terin on 01.07.2025.
//

import Foundation

private extension CGFloat {
    static let defaultSkeletonHeight: CGFloat = 138
}

protocol IMainViewModelFactory: AnyObject {
    func makeViewModels(from articles: [Article]) -> [MainItemViewModel]
    func makeSkeletonItems() -> [MainItem]
}

final class MainViewModelFactory: IMainViewModelFactory {

    private let imageResolverFactory: IImageResolverFactory
    private let publishedDateFormatter: IPublishedDateTimeFormatter
    private let currentDate: Date

    init(
        imageResolverFactory: IImageResolverFactory,
        publishedDateFormatter: IPublishedDateTimeFormatter,
        currentDate: Date = Date()
    ) {
        self.imageResolverFactory = imageResolverFactory
        self.publishedDateFormatter = publishedDateFormatter
        self.currentDate = currentDate
    }

    func makeViewModels(from articles: [Article]) -> [MainItemViewModel] {
        articles.compactMap {
            makeViewModel(from: $0)
        }
    }

    func makeSkeletonItems() -> [MainItem] {
        .skeletonItems
    }

    private func makeViewModel(from article: Article) -> MainItemViewModel? {
        guard
            let urlString = article.url,
            let url = URL(string: urlString),
            let title = article.title,
            let description = getDescription(for: article)
        else {
            return nil
        }

        return MainItemViewModel(
            author: article.author ?? "Unknown author",
            title: title,
            description: description,
            url: url,
            image: getImage(from: article.urlToImage),
            publishedAt: publishedDateFormatter.string(
                from: article.publishedAt,
                currentDate: currentDate
            ),
            content: article.content,
            sourceName: getSourceName(from: article.source)
        )
    }

    private func getDescription(for article: Article) -> String? {
        if let description = article.description {
            return description
        } else if let content = article.content {
            return content
        } else {
            return nil
        }
    }

    private func getImage(from urlToImageString: String?) -> IImageResolver? {
        guard let urlToImageString else { return nil }
        return imageResolverFactory.makeUrlResolver(fromUrlString: urlToImageString)
    }

    private func getSourceName(from source: Source?) -> String {
        if let sourceName = source?.name {
            return sourceName
        } else if let sourceId = source?.id {
            return sourceId
        } else {
            return "Unknown source"
        }
    }
}

extension Array where Element == MainItem {
    static let skeletonItems: [MainItem] = [
        .skeleton(height: .defaultSkeletonHeight),
        .skeleton(height: .defaultSkeletonHeight),
        .skeleton(height: .defaultSkeletonHeight),
        .skeleton(height: .defaultSkeletonHeight),
        .skeleton(height: .defaultSkeletonHeight)
    ]
}
