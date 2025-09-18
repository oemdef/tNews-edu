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
    private let imageLoader: IImageLoader

    init(
        urlRequestFactory: IURLRequestFactory,
        imageLoader: IImageLoader
    ) {
        self.urlRequestFactory = urlRequestFactory
        self.imageLoader = imageLoader
    }
    
    func makeUrlResolver(fromUrlString urlString: String) -> IImageResolver? {
        guard let urlRequest = urlRequestFactory.makeImageUrlRequest(from: urlString) else { return nil }
        return URLImageResolver(urlRequest: urlRequest, imageLoader: imageLoader)
    }
}
