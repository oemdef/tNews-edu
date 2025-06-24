//
//  MainPresenter.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol IMainPresenter: AnyObject {
    func viewDidAppear()
}

final class MainPresenter: IMainPresenter {

    private let router: IMainRouter
    private let everythingService: IEverythingService
    private let topHeadlinesService: ITopHeadlinesService
    private let apiKeyProvider: IAPIKeyProvider

    weak var view: IMainView?

    init(
        router: IMainRouter,
        everythingService: IEverythingService,
        topHeadlinesService: ITopHeadlinesService,
        apiKeyProvider: IAPIKeyProvider
    ) {
        self.router = router
        self.everythingService = everythingService
        self.topHeadlinesService = topHeadlinesService
        self.apiKeyProvider = apiKeyProvider
    }

    func viewDidAppear() {
        guard apiKeyProvider.getApiKey() != nil else {
            let alertConfiguration = AlertConfiguration.enterApiKeyAlert { [weak self] apiKey in
                self?.apiKeyProvider.save(apiKey: apiKey)
                self?.loadArticles()
            }
            router.presentAlert(with: alertConfiguration)
            return
        }

        loadArticles()
    }

    private func loadArticles() {
        topHeadlinesService.loadNew { [weak self] result in
            switch result {
            case .success(let articles):
                DispatchQueue.main.async {
                    self?.view?.set(text: articles)
                }
            case .failure:
                return
            }
        }
    }
}
