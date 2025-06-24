//
//  AlertFactory.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import UIKit

enum AlertConfiguration {
    case enterApiKeyAlert(action: ((String) -> Void)?)
}

protocol IAlertFactory: AnyObject {
    func makeAlert(from configuration: AlertConfiguration) -> UIAlertController
}

final class AlertFactory: IAlertFactory {

    func makeAlert(from configuration: AlertConfiguration) -> UIAlertController {
        switch configuration {
        case .enterApiKeyAlert(let action):
            return makeApiKeyAlert(with: action)
        }
    }

    private func makeApiKeyAlert(with action: ((String) -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(
            title: "Введите ключ API",
            message: "Для работы приложения требуется ввести ключ API NewsAPI",
            preferredStyle: .alert
        )
        alertController.addTextField()

        let submitAction = UIAlertAction(title: "Запомнить", style: .default) { [weak alertController] alertAction in
            guard let key = alertController?.textFields?.first?.text,
                  !key.isEmpty
            else {
                alertAction.isEnabled = false
                return
            }
            action?(key)
        }

        alertController.addAction(submitAction)

        return alertController
    }
}
