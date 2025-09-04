//
//  IImageResolverFactory.swift
//  tNews-edu
//
//  Created by Nikita Terin on 29.07.2025.
//

import Foundation

protocol IImageResolverFactory: AnyObject {
    func makeUrlResolver(fromUrlString urlString: String) -> IImageResolver?
}
