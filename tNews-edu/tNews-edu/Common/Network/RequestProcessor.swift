//
//  RequestProcessor.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol IRequestProcessor: AnyObject {
    func load<Model: Codable>(_ request: IRequest, completion: @escaping (Result<Model, Error>) -> Void)
}

final class RequestProcessor: IRequestProcessor {

    private let urlRequestFactory: IURLRequestFactory

    init(urlRequestFactory: IURLRequestFactory) {
        self.urlRequestFactory = urlRequestFactory
    }

    func load<Model: Decodable>(_ request: IRequest, completion: @escaping (Result<Model, any Error>) -> Void) {
        guard let urlRequest = urlRequestFactory.makeUrlRequest(from: request) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(model))
                return
            } catch {
                completion(.failure(error))
                return
            }
        }.resume()
    }
}
