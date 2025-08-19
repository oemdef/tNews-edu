//
//  TopHeadlinesResponse.swift
//  tNews-edu
//
//  Created by Nikita Terin on 25.06.2025.
//

import Foundation

struct TopHeadlinesResponse: Codable {
    let status: String

    // Normal Response
    let totalResults: Int?
    let articles: [Article]?

    // Error Response
    let code: String?
    let message: String?
}

struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable, Identifiable {
    let id: String?
    let name: String?
}
