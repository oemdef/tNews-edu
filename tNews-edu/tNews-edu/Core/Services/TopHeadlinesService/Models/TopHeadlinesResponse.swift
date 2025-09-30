//
//  TopHeadlinesResponse.swift
//  tNews-edu
//
//  Created by Nikita Terin on 25.06.2025.
//

struct TopHeadlinesResponse: Codable {
    let status: String

    // Normal Response
    let totalResults: Int?
    let articles: [Article]?

    // Error Response
    let code: String?
    let message: String?
}
