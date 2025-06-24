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
        let requestProcessor = RequestProcessor(
            urlRequestFactory: URLRequestFactory(
                apiKeyProvider: apiKeyProvider
            )
        )
        self.entryPointAssembly = MainAssembly(
            alertFactory: AlertFactory(),
            everythingService: EverythingService(requestProcessor: requestProcessor),
            topHeadlinesService: TopHeadlinesService(requestProcessor: requestProcessor),
            apiKeyProvider: apiKeyProvider
        )
    }

    func assemble() -> UIViewController {
        entryPointAssembly.assemble()
    }
}
