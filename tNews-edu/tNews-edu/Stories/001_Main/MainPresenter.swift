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
    private let viewModelFactory: IMainViewModelFactory

    weak var view: IMainView?

    init(
        router: IMainRouter,
        everythingService: IEverythingService,
        topHeadlinesService: ITopHeadlinesService,
        apiKeyProvider: IAPIKeyProvider,
        viewModelFactory: IMainViewModelFactory
    ) {
        self.router = router
        self.everythingService = everythingService
        self.topHeadlinesService = topHeadlinesService
        self.apiKeyProvider = apiKeyProvider
        self.viewModelFactory = viewModelFactory
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
        showSkeletons(animated: false)

        let params = TopHeadlinesRequestParams(language: "en")
        topHeadlinesService.loadNew(params: params) { [weak self] result in
            switch result {
            case .success(let response):
                if let articles = response.articles,
                   let viewModels = self?.viewModelFactory.makeViewModels(from: articles), !viewModels.isEmpty {

                    let items = viewModels.map { MainItem.active(viewModel: $0) }

                    DispatchQueue.main.async {
                        self?.view?.set(items: items, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.router.presentAlert(with: .generic(title: "Произошла ошибка", message: "Error: No Articles"))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.router.presentAlert(with: .generic(title: "Произошла ошибка", message: "\(error)"))
                }
            }
        }
    }

    private func showSkeletons(animated: Bool) {
        view?.set(items: viewModelFactory.makeSkeletonItems(), animated: animated)
    }
}
