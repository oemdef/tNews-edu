//
//  ImageCacher.swift
//  tNews-edu
//
//  Created by Nikita Terin on 20.08.2025.
//

import Foundation
import UIKit

protocol IImageCacher: AnyObject {
    func fetchCachedImage(with url: URL) -> UIImage?
    func save(tempFileUrl: URL, imageUrl: URL)
    func clearCache()
}

final class ImageCacher: IImageCacher {
    private let fileManager: FileManager
    private lazy var imageCachesDirectory: URL? = getCacheDirectory()

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    // MARK: - IImageCacher

    func fetchCachedImage(with url: URL) -> UIImage? {
        guard let imageCachesDirectory else {
            return nil
        }

        let imageUrlInCache = imageCachesDirectory.appendingPathComponent("\(url.hashValue)")

        guard let data = fileManager.contents(atPath: imageUrlInCache.path),
              let image = UIImage(data: data)
        else {
            return nil
        }

        return image
    }

    func save(tempFileUrl: URL, imageUrl: URL) {
        guard let imageCachesDirectory else {
            return
        }

        let imageUrlInCache = imageCachesDirectory.appendingPathComponent("\(imageUrl.hashValue)")

        do {
            try fileManager.moveItem(at: tempFileUrl, to: imageUrlInCache)
        } catch {
            return
        }
    }

    func clearCache() {
        guard let imageCachesDirectory else {
            return
        }

        try? fileManager.removeItem(at: imageCachesDirectory)

        self.imageCachesDirectory = getCacheDirectory()
    }

    // MARK: - Private methods

    private func getCacheDirectory() -> URL? {
        var url: URL?

        guard let cachesDirectory = try? fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) else {
            return nil
        }

        let imageCachePath = cachesDirectory.appendingPathComponent("Images")

        do {
            try fileManager.createDirectory(at: imageCachePath, withIntermediateDirectories: false)
        } catch CocoaError.fileWriteFileExists {
            url = imageCachePath
            return url
        } catch {
            return nil
        }

        url = imageCachePath
        return url
    }
}
