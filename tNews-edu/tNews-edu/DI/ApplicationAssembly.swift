//
//  ApplicationAssembly.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import UIKit

protocol IApplicationAssembly: AnyObject {
    func assemble() -> UIViewController
}

final class ApplicationAssembly: IApplicationAssembly {

    private let entryPointAssembly: IMainAssembly

    init() {
        let apiKeyProvider = APIKeyProvider(keychainManager: KeychainManager())
        let urlRequestFactory = URLRequestFactory(apiKeyProvider: apiKeyProvider)
        let requestProcessor = RequestProcessor(urlRequestFactory: urlRequestFactory)

        let imageCacher = ImageCacher()
        let imageResolverFactory = URLImageResolverFactory(
            urlRequestFactory: urlRequestFactory,
            imageLoader: ImageLoader(imageCacher: imageCacher)
        )

        self.entryPointAssembly = MainAssembly(
            alertFactory: AlertFactory(),
            everythingService: EverythingService(requestProcessor: requestProcessor),
            topHeadlinesService: TopHeadlinesService(requestProcessor: requestProcessor),
            apiKeyProvider: apiKeyProvider,
            viewModelFactory: MainViewModelFactory(
                imageResolverFactory: imageResolverFactory,
                publishedDateFormatter: PublishedDateTimeFormatter()
            ),
            imageCacher: imageCacher
        )
    }

    func assemble() -> UIViewController {
        entryPointAssembly.assemble()
    }
}
