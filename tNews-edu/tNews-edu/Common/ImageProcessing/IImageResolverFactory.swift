//
//  IImageResolverFactory.swift
//  tNews-edu
//
//  Created by Nikita Terin on 29.07.2025.
//

import Foundation

protocol IImageResolverFactory: AnyObject {
    func makeAsyncUrlResolver(fromUrlString urlString: String) -> IImageResolver?
    func makeUrlResolver(fromUrlString urlString: String) -> IImageResolver?
}
