//
//  IImageResolver.swift
//  tNews-edu
//
//  Created by Nikita Terin on 29.07.2025.
//

import Foundation
import UIKit

protocol IImageResolver: AnyObject {
    var identifier: String? { get }
    var contentMode: UIView.ContentMode? { get }

    func resolve(completion: @escaping (UIImage?) -> Void)
    func cancel()
}

extension IImageResolver {
    var contentMode: UIView.ContentMode? {
        nil
    }
}
