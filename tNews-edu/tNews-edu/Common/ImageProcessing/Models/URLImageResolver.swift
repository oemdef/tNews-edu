//
//  URLImageResolver.swift
//  tNews-edu
//
//  Created by Nikita Terin on 02.09.2025.
//

import UIKit

final class URLImageResolver: IImageResolver {
    private let urlRequest: URLRequest
    private let imageLoader: IImageLoader

    var identifier: String? {
        urlRequest.url?.absoluteString
    }

    var contentMode: UIView.ContentMode? {
        .scaleAspectFill
    }

    init(
        urlRequest: URLRequest,
        imageLoader: IImageLoader
    ) {
        self.urlRequest = urlRequest
        self.imageLoader = imageLoader
    }

    func resolve(completion: @escaping (UIImage?) -> Void) {
        imageLoader.loadImage(for: urlRequest) { image in
            completion(image)
        }
    }

    func cancel() {
        imageLoader.cancelLoad(for: urlRequest)
    }
}

extension URLImageResolver: Equatable, Hashable {
    static func == (lhs: URLImageResolver, rhs: URLImageResolver) -> Bool {
        lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
