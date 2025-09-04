//
//  TopHeadlinesService.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol ITopHeadlinesService: AnyObject {
    func loadNew(params: TopHeadlinesRequestParams, completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void)
}

final class TopHeadlinesService: ITopHeadlinesService {

    private let requestProcessor: IRequestProcessor

    init(requestProcessor: IRequestProcessor) {
        self.requestProcessor = requestProcessor
    }

    func loadNew(params: TopHeadlinesRequestParams, completion: @escaping (Result<TopHeadlinesResponse, Error>) -> Void) {
        let request = TopHeadlinesRequest(params: params)
        return requestProcessor.load(request, completion: completion)
    }
}
