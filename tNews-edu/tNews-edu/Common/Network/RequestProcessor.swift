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

        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let model = try decoder.decode(Model.self, from: data)

        return model
    }
}
