//
//  MainViewController.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import UIKit

private extension CGFloat {
    static let itemEstimatedHeight: CGFloat = 138
}

protocol IMainView: AnyObject {
    var isRefreshing: Bool { get }
    func set(items: [MainItem], animated: Bool)
    func endRefreshing()
}

private typealias DataSource = UICollectionViewDiffableDataSource<MainSection, MainItem>
private typealias Snapshot = NSDiffableDataSourceSnapshot<MainSection, MainItem>

final class MainViewController: UIViewController, IMainView {

    // MARK: - Dependencies
    
    private let presenter: IMainPresenter

    // MARK: - Private properties

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    private let refreshControl = UIRefreshControl()
    private lazy var dataSource = makeDataSource()
    private let cellRegistrar = MainCellRegistrar()

    // MARK: - Init
    
    init(presenter: IMainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
    }
    
    // MARK: - IMainView

    var isRefreshing: Bool {
        refreshControl.isRefreshing
    }

    func set(items: [MainItem], animated: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }

    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }

    // MARK: - Private Helpers
    
    private func setup() {
        view.backgroundColor = .systemBackground

        setupNavbar()
        setupHierarchy()
        setupConstraints()
        setupCollectionView()
    }

    private func setupNavbar() {
        title = "tNews"
        navigationController?.navigationBar.prefersLargeTitles = true

        let clearImageCacheBarAction = UIAction { [weak self] _ in
            self?.presenter.clearImageCache()
        }
        let clearImageCacheButton = UIBarButtonItem(systemItem: .trash, primaryAction: clearImageCacheBarAction)

        navigationItem.setRightBarButton(clearImageCacheButton, animated: false)
    }

    private func setupHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.pinEdgesToSuperview()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = self

        let pullToRefreshAction = UIAction { [weak self] _ in
            self?.presenter.reloadItems()
        }
        refreshControl.addAction(pullToRefreshAction, for: .valueChanged)
        collectionView.refreshControl = refreshControl

        cellRegistrar.setup()
    }

    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { [cellRegistrar] collectionView, indexPath, item in
            cellRegistrar.dequeueCell(for: item, collectionView: collectionView, indexPath: indexPath)
        }
    }

    static func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(.itemEstimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // TODO: - Добавить prefetching когда отвяжу логику установки изображения в IImageResolver от загрузки
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // TODO: - Добавить prefetching когда отвяжу логику установки изображения в IImageResolver от загрузки
    }
}
