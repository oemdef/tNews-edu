//
//  URLRequestFactory.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol IURLRequestFactory: AnyObject {
    func makeUrlRequest(from request: IRequest) -> URLRequest?
}

final class URLRequestFactory: IURLRequestFactory {

    private let apiKeyProvider: IAPIKeyProvider

    init(apiKeyProvider: IAPIKeyProvider) {
        self.apiKeyProvider = apiKeyProvider
    }

    func makeUrlRequest(from request: IRequest) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = request.scheme
        urlComponents.host = request.host
        urlComponents.path = request.path
        urlComponents.queryItems = queryItems(from: request.queryParams)

        guard let url = urlComponents.url else { return nil }

        var headers = request.headerFields
        headers["X-Api-Key"] = apiKeyProvider.getApiKey()

        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = request.type.rawValue.uppercased()

        return urlRequest
    }

    private func queryItems(from queryParams: [AnyHashable: Any]) -> [URLQueryItem]? {
        guard !queryParams.isEmpty else { return nil }
        return queryParams.compactMap { name, value in
            let queryItem = URLQueryItem(name: String(describing: name), value: String(describing: value))
            return queryItem
        }
    }
}
