//
//  TopHeadlinesRequestParams.swift
//  tNews-edu
//
//  Created by Nikita Terin on 01.07.2025.
//

struct TopHeadlinesRequestParams {
    let language: String
    let pageSize: Int
    let page: Int

    init(
        language: String,
        pageSize: Int = 30,
        page: Int = 1
    ) {
        self.language = language
        self.pageSize = pageSize
        self.page = page
    }
}
