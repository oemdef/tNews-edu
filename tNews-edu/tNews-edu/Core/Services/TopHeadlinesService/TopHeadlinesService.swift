//
//  TopHeadlinesService.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol ITopHeadlinesService: AnyObject {
    func loadNew(completion: @escaping (Result<String, Error>) -> Void)
}

final class TopHeadlinesService: ITopHeadlinesService {

    private let requestProcessor: IRequestProcessor

    init(requestProcessor: IRequestProcessor) {
        self.requestProcessor = requestProcessor
    }

    func loadNew(completion: @escaping (Result<String, Error>) -> Void) {
        let request = TopHeadlinesRequest(country: "us")
        requestProcessor.load(request) { result in
            switch result {
            case .success(let articles):
                completion(.success(articles))
            case .failure:
                completion(result)
            }
        }
    }
}
