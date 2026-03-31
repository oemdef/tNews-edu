//
//  URLAsyncImageResolver.swift
//  tNews-edu
//
//  Created by Nikita Terin on 31.03.2026.
//

import UIKit

final class URLAsyncImageResolver: IImageResolver {
    private let urlRequest: URLRequest
    private let imageLoader: IAsyncImageLoader

    var identifier: String? {
        urlRequest.url?.absoluteString
    }

    var contentMode: UIView.ContentMode? {
        .scaleAspectFill
    }

    init(
        urlRequest: URLRequest,
        imageLoader: IAsyncImageLoader
    ) {
        self.urlRequest = urlRequest
        self.imageLoader = imageLoader
    }

    func resolve(completion: @escaping (UIImage?) -> Void) {
        Task.detached { [urlRequest, imageLoader] in
            let image = try? await imageLoader.loadImage(for: urlRequest)

            await MainActor.run {
                completion(image)
            }
        }
    }

    func cancel() {
        Task.detached { [urlRequest, imageLoader] in
            await imageLoader.cancelLoad(for: urlRequest)
        }
    }
}

extension URLAsyncImageResolver: Equatable, Hashable {
    static func == (lhs: URLAsyncImageResolver, rhs: URLAsyncImageResolver) -> Bool {
        lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
