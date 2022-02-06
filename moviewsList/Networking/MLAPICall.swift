//
//  MLAPICall.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 22/01/22.
//

import Foundation

protocol MLAPICall {
    var path: String { get }
    var microServiceMethod:String {get}
    var method: String { get }
    var headers: [String: String]? { get }
    var microService: String { get }
    func body() throws -> Data?
    func buildUrlString()throws -> String
}

enum MLAPIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageProcessing([URLRequest])
}

extension MLAPIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageProcessing: return "Unable to load image"
        }
    }
}

extension MLAPICall {
    func configuration() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL) else {
            throw MLError.requestBuildFailure.urlCreationFailed
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
