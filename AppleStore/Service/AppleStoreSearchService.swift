//
//  AppleStoreSearchService.swift
//  AppleStore
//
//  Created by yjlee12 on 2022/02/17.
//

import Foundation
import UIKit
import Combine

class AppleStoreSearchService {
    typealias ErrorFactory = AppleStoreSearchServiceErrorFactory
    static let shared = AppleStoreSearchService()
    private let urlSession = URLSession.shared
    private let url = "https://itunes.apple.com/search"
    
    func getList(_ query: String) -> AnyPublisher<AppResponse, Error> {
        guard let queryUrl = URL(string:"https://itunes.apple.com/search" + "?" + "term=\(query)&entity=software,iPadSoftware&limit=10") else {
            return Fail(error: ErrorFactory.invalidUrl()).eraseToAnyPublisher()
        }
        
        return urlSession.dataTaskPublisher(for: queryUrl)
            .mapError { urlError -> NSError in
                return ErrorFactory.requestFailed(parameters: ["query": query], underlying: urlError)
            }
            .tryMap(\.data)
            .mapError { error -> NSError in
                return ErrorFactory.responseFailed(underlying: error)
            }
            .decode(type: AppResponse.self, decoder: JSONDecoder())
            .mapError { error in
                return ErrorFactory.decodeFailed(underlying: error)
            }
            .eraseToAnyPublisher()
    }
}

enum AppleStoreSearchServiceErrorFactory: ErrorFactory {
    enum Code: Int {
        case queryFailed = 0
        case invalidUrl = 1
        case responseFailed = 2
        case decodeFailed = 3
        case requestFailed = 4
    }
    static func queryFailed() -> NSError {
        return NSError(
            domain: domain,
            code: Code.queryFailed.rawValue,
            userInfo: [
                "identifier": String(reflecting: Code.queryFailed)
            ]
        )
    }
    
    static func invalidUrl() -> NSError {
        return NSError(
            domain: domain,
            code: Code.invalidUrl.rawValue,
            userInfo: [
                "identifier": String(reflecting: Code.invalidUrl)
            ]
        )
    }
    
    static func responseFailed(underlying: Error) -> NSError {
        return NSError(
            domain: domain, code: Code.responseFailed.rawValue,
            userInfo: [
                NSUnderlyingErrorKey: underlying,
                "identifier": String(reflecting: Code.responseFailed),
            ]
        )
    }
    
    static func decodeFailed(underlying: Error) -> NSError {
        return NSError(
            domain: domain, code: Code.decodeFailed.rawValue,
            userInfo: [
                NSUnderlyingErrorKey: underlying,
                "identifier": String(reflecting: Code.decodeFailed),
            ]
        )
    }
    
    static func requestFailed(parameters: [String: String], underlying: Error) -> NSError {
        return NSError(
            domain: domain, code: Code.requestFailed.rawValue,
            userInfo: [
                "parameters": parameters,
                NSUnderlyingErrorKey: underlying,
                "identifier": String(reflecting: Code.requestFailed),
            ]
        )
    }
}
