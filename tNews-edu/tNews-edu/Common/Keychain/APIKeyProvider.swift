//
//  APIKeyProvider.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

protocol IAPIKeyProvider: AnyObject {
    func getApiKey() -> String?
    func save(apiKey: String)
}

private extension String {
    static let kcServiceKey = "x-api-key"
    static let kcAccountKey = "newsapi"
}

final class APIKeyProvider: IAPIKeyProvider {

    private let keychainManager: IKeychainManager

    init(keychainManager: IKeychainManager) {
        self.keychainManager = keychainManager
    }

    func getApiKey() -> String? {
        guard let apiKeyData = keychainManager.read(service: .kcServiceKey, account: .kcAccountKey) else { return nil }
        return String(data: apiKeyData, encoding: .utf8)
    }

    func save(apiKey: String) {
        let apiKeyData = Data(apiKey.utf8)
        keychainManager.save(apiKeyData, service: .kcServiceKey, account: .kcAccountKey)
    }
}
