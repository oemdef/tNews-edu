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
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
