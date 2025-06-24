//
//  BaseRequest.swift
//  tNews-edu
//
//  Created by Nikita Terin on 17.06.2025.
//

class BaseRequest: IRequest {

    var type: RequestType {
        .get
    }

    final var scheme: String {
        "https"
    }
    
    final var host: String {
        "newsapi.org"
    }
    
    var service: String {
        "everything"
    }

    final var path: String {
        "/v2/\(service)"
    }

    var headerFields: [String: String] {
        [String: String]()
    }

    var queryParams: [AnyHashable: Any] {
        [AnyHashable: Any]()
    }
}
