//
//  URLImageResolverFactory.swift
//  tNews-edu
//
//  Created by Nikita Terin on 29.07.2025.
//

import Foundation
import UIKit

final class URLImageResolverFactory: IImageResolverFactory {

    private let urlRequestFactory: IURLRequestFactory
    private let asyncImageLoader: IAsyncImageLoader
    private let imageLoader: IImageLoader

    init(
        urlRequestFactory: IURLRequestFactory,
        asyncImageLoader: IAsyncImageLoader,
        imageLoader: IImageLoader
    ) {
        self.urlRequestFactory = urlRequestFactory
        self.asyncImageLoader = asyncImageLoader
        self.imageLoader = imageLoader
    }

    func makeAsyncUrlResolver(fromUrlString urlString: String) -> IImageResolver? {
        guard let urlRequest = urlRequestFactory.makeImageUrlRequest(from: urlString) else { return nil }
        return URLAsyncImageResolver(urlRequest: urlRequest, imageLoader: asyncImageLoader)
    }

    func makeUrlResolver(fromUrlString urlString: String) -> IImageResolver? {
        guard let urlRequest = urlRequestFactory.makeImageUrlRequest(from: urlString) else { return nil }
        return URLImageResolver(urlRequest: urlRequest, imageLoader: imageLoader)
    }
}
