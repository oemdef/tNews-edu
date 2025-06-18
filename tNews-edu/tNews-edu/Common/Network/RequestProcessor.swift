//
//  RequestProcessor.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol IRequestProcessor: AnyObject {
    func load(_ request: IRequest, completion: @escaping (Result<String, Error>) -> Void)
}

final class RequestProcessor: IRequestProcessor {

    private let urlRequestFactory: IURLRequestFactory

    init(urlRequestFactory: IURLRequestFactory) {
        self.urlRequestFactory = urlRequestFactory
    }

    func load(_ request: IRequest, completion: @escaping (Result<String, any Error>) -> Void) {
        guard let urlRequest = urlRequestFactory.makeUrlRequest(from: request) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            guard let string = String(data: data, encoding: .utf8) else {
                completion(.failure(NetworkError.failedToParse))
                return
            }

            completion(.success(string))
        }.resume()
    }
}
