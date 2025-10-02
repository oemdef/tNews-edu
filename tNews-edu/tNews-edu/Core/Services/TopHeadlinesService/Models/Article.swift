//
//  Article.swift
//  tNews-edu
//
//  Created by Nikita Terin on 24.09.2025.
//

import Foundation

struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
}
