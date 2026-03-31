//
//  IURLSession.swift
//  tNews-edu
//
//  Created by Nikita Terin on 19.08.2025.
//

import Foundation

protocol IURLSession: AnyObject {
    var configuration: URLSessionConfiguration { get }

    func data(
        for request: URLRequest,
        delegate: (URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse)
    func download(
        for request: URLRequest,
        delegate: (URLSessionTaskDelegate)?
    ) async throws -> (URL, URLResponse)

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTask
    func downloadTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (URL?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDownloadTask
}

extension IURLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
    func download(for request: URLRequest) async throws -> (URL, URLResponse) {
        try await download(for: request, delegate: nil)
    }
}

extension URLSession: IURLSession {}
