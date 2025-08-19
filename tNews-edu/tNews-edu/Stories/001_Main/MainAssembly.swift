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
    private let viewModelFactory: IMainViewModelFactory

    init(
        alertFactory: IAlertFactory,
        everythingService: IEverythingService,
        topHeadlinesService: ITopHeadlinesService,
        apiKeyProvider: IAPIKeyProvider,
        viewModelFactory: IMainViewModelFactory
    ) {
        self.alertFactory = alertFactory
        self.everythingService = everythingService
        self.topHeadlinesService = topHeadlinesService
        self.apiKeyProvider = apiKeyProvider
        self.viewModelFactory = viewModelFactory
    }

    func assemble() -> UIViewController {
        let router = MainRouter(alertFactory: alertFactory)

        let presenter = MainPresenter(
            router: router,
            everythingService: everythingService,
            topHeadlinesService: topHeadlinesService,
            apiKeyProvider: apiKeyProvider,
            viewModelFactory: viewModelFactory
        )
        let viewController = MainViewController(presenter: presenter)

        presenter.view = viewController
        router.transitionHandler = viewController

        return viewController
    }
}
