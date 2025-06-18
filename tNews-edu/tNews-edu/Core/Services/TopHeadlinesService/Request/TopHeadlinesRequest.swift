//
//  TopHeadlinesRequest.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

final class TopHeadlinesRequest: BaseRequest {

    private let country: String

    init(country: String) {
        self.country = country
    }

    override func queryParams() -> [AnyHashable : Any] {
        ["country": country]
    }

    override func service() -> String {
        "top-headlines"
    }
}
