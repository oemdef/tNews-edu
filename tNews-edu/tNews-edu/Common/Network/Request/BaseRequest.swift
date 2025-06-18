//
//  BaseRequest.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

class BaseRequest: IRequest {

    func type() -> RequestType {
        .get
    }

    final func scheme() -> String {
        "https"
    }
    
    final func host() -> String {
        "newsapi.org"
    }
    
    func service() -> String {
        "everything"
    }

    final func path() -> String {
        "/v2/\(service())"
    }

    func headerFields() -> [String: String] {
        [String: String]()
    }

    func queryParams() -> [AnyHashable: Any] {
        [AnyHashable: Any]()
    }
}
