//
//  MainPresenter.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol IMainPresenter: AnyObject {
    func viewDidAppear()
    func reloadItems()
    func clearImageCache()
}

final class MainPresenter: IMainPresenter {

    private let router: IMainRouter
    private let everythingService: IEverythingService
    private let topHeadlinesService: ITopHeadlinesService
    private let apiKeyProvider: IAPIKeyProvider
    private let viewModelFactory: IMainViewModelFactory
    private let imageCacher: IImageCacher

    weak var view: IMainView?

    init(
        router: IMainRouter,
        everythingService: IEverythingService,
        topHeadlinesService: ITopHeadlinesService,
        apiKeyProvider: IAPIKeyProvider,
        viewModelFactory: IMainViewModelFactory,
        imageCacher: IImageCacher
    ) {
        self.router = router
        self.everythingService = everythingService
        self.topHeadlinesService = topHeadlinesService
        self.apiKeyProvider = apiKeyProvider
        self.viewModelFactory = viewModelFactory
        self.imageCacher = imageCacher
    }

    func viewDidAppear() {
        reloadItems()
    }

    func reloadItems() {
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

    func clearImageCache() {
        imageCacher.clearCache()
    }

    private func loadArticles() {
        if view?.isRefreshing != true {
            showSkeletons(animated: false)

            topHeadlinesService.fetchCached { [weak self] cachedArticles in
                if !cachedArticles.isEmpty,
                   let viewModels = self?.viewModelFactory.makeViewModels(from: cachedArticles),
                   !viewModels.isEmpty {

                    let items = viewModels.map { MainItem.active(viewModel: $0) }

                    DispatchQueue.main.async {
                        self?.view?.set(items: items, animated: false)
                    }
                }
            }
        }

        let params = TopHeadlinesRequestParams(language: "en")
        topHeadlinesService.loadNew(params: params) { [weak self] result in
            switch result {
            case .success(let articles):
                if let viewModels = self?.viewModelFactory.makeViewModels(from: articles), !viewModels.isEmpty {

                    let items = viewModels.map { MainItem.active(viewModel: $0) }

                    DispatchQueue.main.async {
                        self?.view?.set(items: items, animated: true)
                        self?.view?.endRefreshing()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.router.presentAlert(with: .generic(title: "Произошла ошибка", message: "Error: No Articles"))
                        self?.view?.endRefreshing()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.router.presentAlert(with: .generic(title: "Произошла ошибка", message: "\(error.localizedDescription)"))
                    self?.view?.endRefreshing()
                }
            }
        }
    }

    private func showSkeletons(animated: Bool) {
        view?.set(items: viewModelFactory.makeSkeletonItems(), animated: animated)
    }
}
