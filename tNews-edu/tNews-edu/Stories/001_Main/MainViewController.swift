//
//  MainViewController.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import UIKit

protocol IMainView: AnyObject {
    func set(text: String)
}

final class MainViewController: UIViewController, IMainView {
    
    // MARK: - Dependencies
    
    private let presenter: IMainPresenter
    
    // MARK: - UI
    
    private let textView: UITextView = {
        let view = UITextView()
        view.text = "Hello, World!"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    func set(text: String) {
        textView.text = text
    }
    
    // MARK: - Private Helpers
    
    private func setup() {
        view.backgroundColor = .systemBackground
        
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        view.addSubview(textView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: super.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
