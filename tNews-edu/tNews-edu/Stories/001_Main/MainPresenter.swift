//
//  MainPresenter.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol IMainPresenter: AnyObject {
    func viewDidAppear() async
    func reloadItems() async
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

    func viewDidAppear() async {
        await reloadItems()
    }

    func reloadItems() async {
        guard apiKeyProvider.getApiKey() != nil else {
            let alertConfiguration = AlertConfiguration.enterApiKeyAlert { [weak self] apiKey in
                self?.apiKeyProvider.save(apiKey: apiKey)
                Task.detached {
                    await self?.loadArticles()
                }
            }
            await router.presentAlert(with: alertConfiguration)
            return
        }

        await loadArticles()
    }

    func clearImageCache() {
        imageCacher.clearCache()
    }

    private func loadArticles() async {
        if await view?.isRefreshing != true {
            showSkeletons(animated: false)

            let cachedArticles = await topHeadlinesService.fetchCached()
            let viewModels = viewModelFactory.makeViewModels(from: cachedArticles)

            if !viewModels.isEmpty {
                let items = viewModels.map { MainItem.active(viewModel: $0) }
                view?.set(items: items, animated: false)
            }
        }

        let params = TopHeadlinesRequestParams(language: "en")

        do {
            let loadedArticles = try await topHeadlinesService.loadNew(params: params)
            let viewModels = viewModelFactory.makeViewModels(from: loadedArticles)

            guard !viewModels.isEmpty else {
                await router.presentAlert(with: .generic(title: "Произошла ошибка", message: "Error: No Articles"))
                await view?.endRefreshing()
                return
            }

            let items = viewModels.map { MainItem.active(viewModel: $0) }

            view?.set(items: items, animated: true)
            await view?.endRefreshing()
        } catch {
            await router.presentAlert(with: .generic(title: "Произошла ошибка", message: "\(error.localizedDescription)"))
            await view?.endRefreshing()
        }
    }

    private func showSkeletons(animated: Bool) {
        view?.set(items: viewModelFactory.makeSkeletonItems(), animated: animated)
    }
}
