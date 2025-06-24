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

    override var queryParams: [AnyHashable : Any] {
        ["country": country]
    }

    override var service: String {
        "top-headlines"
    }
}
