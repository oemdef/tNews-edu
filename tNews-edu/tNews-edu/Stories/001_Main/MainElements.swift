//
//  MainElements.swift
//  tNews-edu
//
//  Created by Nikita Terin on 01.07.2025.
//

import Foundation

enum MainSection: Hashable {
    case main
}

enum MainItem: Hashable {
    case skeleton(id: UUID = UUID(), height: CGFloat)
    case active(viewModel: MainItemViewModel)
}

extension MainItem: Identifiable {
    var id: String {
        switch self {
        case .skeleton(let id, _):
            return id.uuidString
        case .active(let viewModel):
            return viewModel.id
        }
    }
}
