//
//  RequestProcessor.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol IRequestProcessor: AnyObject {
    func load<Model: Codable>(_ request: IRequest) async throws -> Model
}

final class RequestProcessor: IRequestProcessor {

    private let urlRequestFactory: IURLRequestFactory

    init(urlRequestFactory: IURLRequestFactory) {
        self.urlRequestFactory = urlRequestFactory
    }

    func load<Model: Decodable>(_ request: any IRequest) async throws -> Model {
        guard let urlRequest = urlRequestFactory.makeUrlRequest(from: request) else {
            throw NetworkError.invalidUrl
        }

        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                if let error {
                    continuation.resume(throwing: error)
                }

                guard let data else {
                    continuation.resume(throwing: NetworkError.noData)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601

                    let model = try decoder.decode(Model.self, from: data)
                    continuation.resume(returning: model)
                } catch {
                    continuation.resume(throwing: error)
                }
            }.resume()
        }
    }
}
