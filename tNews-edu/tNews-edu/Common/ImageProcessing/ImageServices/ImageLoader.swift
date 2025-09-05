//
//  ImageLoader.swift
//  tNews-edu
//
//  Created by Nikita Terin on 19.08.2025.
//

import Foundation
import UIKit

protocol IImageLoader: AnyObject {
    func loadImage(
        for urlRequest: URLRequest,
        completion: @escaping (UIImage?) -> Void
    )
    func cancelLoad(for urlRequest: URLRequest)
}

final class ImageLoader: IImageLoader {

    private let imageCacher: IImageCacher
    private let urlSession: IURLSession

    private let imageLoadingQueue: DispatchQueue
    private let semaphore: DispatchSemaphore

    private let lock: NSLock = NSLock()

    private var downloadTasks: [URL: URLSessionDownloadTask] = [:]

    init(
        imageCacher: IImageCacher,
        urlSession: IURLSession = URLSession.shared,
        imageLoadingQueue: DispatchQueue = DispatchQueue(label: "concurrent-image-queue", attributes: .concurrent)
    ) {
        self.imageCacher = imageCacher
        self.urlSession = urlSession
        self.imageLoadingQueue = imageLoadingQueue

        self.semaphore = DispatchSemaphore(
            value: urlSession.configuration.httpMaximumConnectionsPerHost
        )
    }

    func loadImage(
        for urlRequest: URLRequest,
        completion: @escaping (UIImage?) -> Void
    ) {
        guard let url = urlRequest.url else {
            completion(nil)
            return
        }

        if let cachedImage = imageCacher.fetchCachedImage(with: url) {
            completion(cachedImage)
            return
        }

        var activeTask: URLSessionDownloadTask?

        lock.withLock {
            activeTask = downloadTasks[url]
        }

        guard activeTask == nil else { return }

        createAndEnqueueTask(
            for: urlRequest,
            onEnqueue: { [weak self, lock] downloadTask in
                lock.withLock {
                    self?.downloadTasks[url] = downloadTask
                }
            },
            completion: { [weak self, lock] image in
                lock.withLock {
                    self?.downloadTasks[url] = nil
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        )
    }

    func cancelLoad(for urlRequest: URLRequest) {
        guard let url = urlRequest.url else { return }

        var downloadTask: URLSessionDownloadTask?

        lock.withLock {
            downloadTask = downloadTasks[url]
        }

        guard let downloadTask else { return }

        downloadTask.cancel()
    }

    private func createAndEnqueueTask(
        for urlRequest: URLRequest,
        onEnqueue: @escaping (URLSessionDownloadTask) -> Void,
        completion: @escaping (UIImage?) -> Void
    ) {
        guard let url = urlRequest.url else {
            completion(nil)
            return
        }

        imageLoadingQueue.async { [urlSession, semaphore, imageCacher] in
            // Create task
            let task = urlSession.downloadTask(with: urlRequest) { [semaphore, imageCacher] tempFileUrl, response, error in
                defer {
                    semaphore.signal()
                }

                guard
                    error == nil,
                    let tempFileUrl,
                    let data = FileManager.default.contents(atPath: tempFileUrl.path),
                    let image = UIImage(data: data)
                else {
                    completion(nil)
                    return
                }

                imageCacher.save(tempFileUrl: tempFileUrl, imageUrl: url)

                completion(image)
            }

            // Enqueue and start task
            onEnqueue(task)
            semaphore.wait()
            task.resume()
        }
    }
}
