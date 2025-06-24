//
//  IRequest.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

protocol IRequest: AnyObject {
    var type: RequestType { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var service: String { get }
    var headerFields: [String: String] { get }
    var queryParams: [AnyHashable: Any] { get }
}
