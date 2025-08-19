//
//  MainItemViewModel.swift
//  tNews-edu
//
//  Created by Nikita Terin on 01.07.2025.
//

import Foundation

struct MainItemViewModel: Identifiable, Hashable {
    var id: String {
        url.absoluteString
    }

    let author: String
    let title: String
    let urlToImage: URL?
    let description: String?
    let url: URL
    let publishedAt: String?
    let content: String?
    let sourceName: String
}
