//
//  IURLSession.swift
//  tNews-edu
//
//  Created by Nikita Terin on 19.08.2025.
//

import Foundation

protocol IURLSession: AnyObject {
    var configuration: URLSessionConfiguration { get }

    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask
    func downloadTask(with request: URLRequest, completionHandler: @escaping @Sendable (URL?, URLResponse?, (any Error)?) -> Void) -> URLSessionDownloadTask
}

extension URLSession: IURLSession {}
