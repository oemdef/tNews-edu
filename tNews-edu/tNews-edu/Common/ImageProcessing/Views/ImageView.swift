//
//  ImageView.swift
//  tNews-edu
//
//  Created by Nikita Terin on 03.09.2025.
//

import UIKit

private extension String {
    static let skeletonAnimationKey = "skeletonAnimation"
}

final class ImageView: UIImageView {
    var storedResolver: IImageResolver? {
        didSet {
            if let storedResolver {
                applyResolver(storedResolver)
            }
        }
    }

    func apply(_ imageResolver: IImageResolver?) {
        // check if resolver isn't stored in the image view
        guard isNotStored(imageResolver) else { return }

        // reset stored resolver
        resetResolver()

        // store and apply new resolver
        storedResolver = imageResolver
    }

    func resetResolver() {
        // clear stored resolver and image
        storedResolver?.cancel()
        storedResolver = nil
        image = nil

        // add skeleton animation
        layer.add(.endlessPulseAnimation, forKey: .skeletonAnimationKey)
    }

    private func applyResolver(_ resolver: IImageResolver?) {
        let resultContentMode = resolver?.contentMode ?? contentMode

        resolver?.resolve { image in
            guard let currentResolver = self.storedResolver, resolver === currentResolver else { return }

            if let image {
                self.layer.removeAllAnimations()
                self.image = image
                self.contentMode = resultContentMode
            }
        }
    }

    // MARK: - Helpers

    private func isNotStored(_ newResolver: IImageResolver?) -> Bool {
        if storedResolver === newResolver { return false }

        if let newResolverId = newResolver?.identifier,
           let storedResolverId = storedResolver?.identifier,
           storedResolverId == newResolverId {
            return false
        }

        return true
    }
}
