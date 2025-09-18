//
//  MainItemViewModel.swift
//  tNews-edu
//
//  Created by Nikita Terin on 01.07.2025.
//

import Foundation

struct MainItemViewModel: Identifiable {
    var id: String {
        url.absoluteString
    }

    let author: String
    let title: String
    let description: String?
    let url: URL
    let image: IImageResolver?
    let publishedAt: String?
    let content: String?
    let sourceName: String
}

extension MainItemViewModel: Hashable {
    static func == (lhs: MainItemViewModel, rhs: MainItemViewModel) -> Bool {
        lhs.author == rhs.author &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.url == rhs.url &&
        lhs.image?.identifier == rhs.image?.identifier &&
        lhs.publishedAt == rhs.publishedAt &&
        lhs.content == rhs.content &&
        lhs.sourceName == rhs.sourceName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(author)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(url)
        hasher.combine(image?.identifier)
        hasher.combine(publishedAt)
        hasher.combine(content)
        hasher.combine(sourceName)
    }
}
