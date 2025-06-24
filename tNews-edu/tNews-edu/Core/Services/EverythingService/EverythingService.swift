//
//  EverythingService.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol IEverythingService: AnyObject {
    func loadNew(completion: @escaping (Result<String, Error>) -> Void)
}

final class EverythingService: IEverythingService {

    private let requestProcessor: IRequestProcessor

    init(requestProcessor: IRequestProcessor) {
        self.requestProcessor = requestProcessor
    }

    func loadNew(completion: @escaping (Result<String, Error>) -> Void) {
        let request = EverythingRequest()
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
