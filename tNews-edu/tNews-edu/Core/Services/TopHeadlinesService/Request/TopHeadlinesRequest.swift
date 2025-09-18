//
//  TopHeadlinesRequest.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

import Foundation

final class TopHeadlinesRequest: BaseRequest {

    private let language: String
    private let pageSize: Int
    private let page: Int

    init(params: TopHeadlinesRequestParams) {
        self.language = params.language
        self.pageSize = params.pageSize
        self.page = params.page
    }

    override var queryParams: [AnyHashable: Any] {
        [
            "language": language,
            "pageSize": pageSize,
            "page": page
        ]
    }

    override var service: String {
        "top-headlines"
    }
}
