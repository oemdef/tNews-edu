//
//  IRequest.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

protocol IRequest {
    func type() -> RequestType
    func scheme() -> String
    func host() -> String
    func path() -> String
    func service() -> String
    func headerFields() -> [String: String]
    func queryParams() -> [AnyHashable: Any]
}
