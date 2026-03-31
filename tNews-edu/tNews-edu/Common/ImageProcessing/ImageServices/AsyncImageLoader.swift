//
//  AsyncImageLoader.swift
//  tNews-edu
//
//  Created by Nikita Terin on 31.03.2026.
//

import Foundation
import UIKit

protocol IAsyncImageLoader: AnyObject {
    func loadImage(for urlRequest: URLRequest) async throws -> UIImage
    func cancelLoad(for urlRequest: URLRequest) async
}

final class AsyncImageLoader: IAsyncImageLoader {
    enum AsyncImageStatus {
        case inProgress(Task<UIImage, Error>)
        case fetched(UIImage)
    }

    private let imageCacher: IAsyncImageCacher
    private let urlSession: IURLSession
    private let lock: NSLock = NSLock()

    private var asyncImages: [URL: AsyncImageStatus] = [:]

    init(
        imageCacher: IAsyncImageCacher,
        urlSession: IURLSession = URLSession.shared
    ) {
        self.imageCacher = imageCacher
        self.urlSession = urlSession
    }

    func loadImage(for urlRequest: URLRequest) async throws -> UIImage {
        guard let url = urlRequest.url else {
            throw NetworkError.invalidUrl
        }

        if let imageStatus = getStatus(for: url) {
            switch imageStatus {
            case .fetched(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }

        if let cachedImage = await imageCacher.fetchCachedImage(with: url) {
            setStatus(.fetched(cachedImage), for: url)
            return cachedImage
        }

        let task: Task<UIImage, Error> = Task.detached { [urlSession, imageCacher] in
            let (tempFileUrl, _) = try await urlSession.download(for: urlRequest)

            guard
                let data = FileManager.default.contents(atPath: tempFileUrl.path),
                let image = UIImage(data: data)
            else {
                throw NetworkError.noData
            }

            Task.detached {
                await imageCacher.save(tempFileUrl: tempFileUrl, imageUrl: url)
            }

            return image
        }

        setStatus(.inProgress(task), for: url)

        let loadedImage = try await task.value

        setStatus(.fetched(loadedImage), for: url)

        return loadedImage
    }

    func cancelLoad(for urlRequest: URLRequest) {
        guard let url = urlRequest.url else { return }

        if let imageStatus = getStatus(for: url) {
            switch imageStatus {
            case .fetched:
                return
            case .inProgress(let task):
                task.cancel()
                setStatus(nil, for: url)
            }
        }
    }

    // MARK: - Private

    private func getStatus(for url: URL) -> AsyncImageStatus? {
        lock.withLock {
            return asyncImages[url]
        }
    }

    private func setStatus(_ status: AsyncImageStatus?, for url: URL) {
        lock.withLock {
            asyncImages[url] = status
        }
    }
}
