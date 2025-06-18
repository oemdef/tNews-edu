//
//  MainRouter.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import UIKit

protocol IMainRouter: AnyObject {
    func presentAlert(with configuration: AlertConfiguration)
}

final class MainRouter: IMainRouter {

    private let alertFactory: IAlertFactory

    weak var transitionHandler: UIViewController?

    init(alertFactory: IAlertFactory) {
        self.alertFactory = alertFactory
    }

    func presentAlert(with configuration: AlertConfiguration) {
        let alert = alertFactory.makeAlert(from: configuration)
        transitionHandler?.present(alert, animated: true)
    }
}
