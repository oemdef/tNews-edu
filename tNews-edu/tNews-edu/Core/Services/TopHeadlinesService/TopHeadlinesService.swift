//
//  TopHeadlinesService.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol ITopHeadlinesService: AnyObject {
    func fetchCached(completion: @escaping (([Article]) -> Void))
    func loadNew(params: TopHeadlinesRequestParams, completion: @escaping (Result<[Article], Error>) -> Void)
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

    func fetchCached(completion: @escaping ([Article]) -> Void) {
        let sortByDateDesc = NSSortDescriptor(key: "publishedAt", ascending: false)
        let cachedArticles = storage.fetch(Article.self, sortDescriptors: [sortByDateDesc])
        completion(cachedArticles)
    }

    func loadNew(params: TopHeadlinesRequestParams, completion: @escaping (Result<[Article], Error>) -> Void) {
        let request = TopHeadlinesRequest(params: params)
        let loadCompletion: (Result<TopHeadlinesResponse, Error>) -> Void = { [storage] result in
            switch result {
            case .success(let response):
                let articles: [Article] = response.articles ?? []
                storage.replaceAll(articles)
                completion(.success(articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        requestProcessor.load(request, completion: loadCompletion)
    }
}
