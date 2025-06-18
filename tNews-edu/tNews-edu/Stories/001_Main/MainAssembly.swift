//
//  MainAssembly.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import UIKit

protocol IMainAssembly: AnyObject {
    func assemble() -> UIViewController
}

final class MainAssembly: IMainAssembly {

    private let alertFactory: IAlertFactory
    private let everythingService: IEverythingService
    private let topHeadlinesService: ITopHeadlinesService
    private let apiKeyProvider: IAPIKeyProvider

    init(
        alertFactory: IAlertFactory,
        everythingService: IEverythingService,
        topHeadlinesService: ITopHeadlinesService,
        apiKeyProvider: IAPIKeyProvider
    ) {
        self.alertFactory = alertFactory
        self.everythingService = everythingService
        self.topHeadlinesService = topHeadlinesService
        self.apiKeyProvider = apiKeyProvider
    }

    func assemble() -> UIViewController {
        let router = MainRouter(alertFactory: alertFactory)

        let presenter = MainPresenter(
            router: router,
            everythingService: everythingService,
            topHeadlinesService: topHeadlinesService,
            apiKeyProvider: apiKeyProvider
        )
        let viewController = MainViewController(presenter: presenter)

        presenter.view = viewController
        router.transitionHandler = viewController

        return viewController
    }
}
