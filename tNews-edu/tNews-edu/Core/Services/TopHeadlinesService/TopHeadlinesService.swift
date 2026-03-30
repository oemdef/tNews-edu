//
//  TopHeadlinesService.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol ITopHeadlinesService: AnyObject {
    func fetchCached() async -> [Article]
    func loadNew(params: TopHeadlinesRequestParams) async throws -> [Article]
}

final class TopHeadlinesService: ITopHeadlinesService {

    private let storage: IStorage
    private let requestProcessor: IRequestProcessor

    init(
        storage: IStorage,
        requestProcessor: IRequestProcessor
    ) {
        self.storage = storage
        self.requestProcessor = requestProcessor
    }

    func fetchCached() async -> [Article] {
        let sortByDateDesc = NSSortDescriptor(key: "publishedAt", ascending: false)

        return await withCheckedContinuation { continuation in
            let cachedArticles = storage.fetch(Article.self, sortDescriptors: [sortByDateDesc])
            continuation.resume(returning: cachedArticles)
        }
    }

    func loadNew(params: TopHeadlinesRequestParams) async throws -> [Article] {
        let request = TopHeadlinesRequest(params: params)

        let response: TopHeadlinesResponse = try await requestProcessor.load(request)
        let articles: [Article] = response.articles ?? []

        Task.detached(priority: .utility) { [storage] in
            await withCheckedContinuation { continuation in
                storage.replaceAll(articles)
                continuation.resume()
            }
        }

        return articles
    }
}
