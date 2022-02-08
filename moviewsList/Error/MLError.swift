//
//  MLError.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 02/02/22.
//

import Foundation
enum MLError:Error {
    enum authenticationFailure:Int,Error {
        case serverAuthenticationError = 1001
    }
    enum apiFailure:Int,Error {
        case noData = 2001
        case badRequest = 2002
        case outDated = 2003
        case netWorkError = 2004
        case noResponse = 2005
        case connectivityError = 2006
        
    }
    enum requestBuildFailure:Int,Error {
        case missingURL = 3001
        case urlCreationFailed = 3002
        case undefinedInput = 3003
    }
    enum jsonEncodingFailure:Int,Error {
        case encodingFailed = 4001
        case decodeFailed = 4002
    }
    enum badAccessInstance:Int,Error {
        case forbidden = 5001
    }
}
extension MLError.authenticationFailure:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverAuthenticationError:
            return MLConstants.errorMessage.endPointFailed
        }
    }
    var debugDescription: String {
        return "\(String(describing: type(of: self))).\(String(describing: self)) (\(MLConstants.fieldNames.code) \((self as NSError).code))"
    }
    
}
extension MLError.apiFailure:LocalizedError {
     var errorDescription: String? {
        switch self {
        case .noData:
            return MLConstants.errorMessage.noData
        case .badRequest:
            return MLConstants.errorMessage.badRequest
        case .outDated:
            return MLConstants.errorMessage.outdated
        case .netWorkError:
            return MLConstants.errorMessage.networkRequestFailed
        case .noResponse:
            return MLConstants.errorMessage.parseError
        case .connectivityError:
            return MLConstants.errorMessage.connectivityError
        }
    }
    var debugDescription: String {
        return "\(String(describing: type(of: self))).\(String(describing: self)) (\(MLConstants.fieldNames.code) \((self as NSError).code))"
    }
}
extension MLError.requestBuildFailure:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingURL:
            return MLConstants.errorMessage.nilParam
        case .urlCreationFailed:
            return MLConstants.errorMessage.urlRequestFailed
        case .undefinedInput:
            return MLConstants.errorMessage.undefinedInput
        }
    }
    var debugDescription: String {
        return "\(String(describing: type(of: self))).\(String(describing: self)) (\(MLConstants.fieldNames.code) \((self as NSError).code))"
    }
}
extension MLError.jsonEncodingFailure:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return MLConstants.errorMessage.jsonEncodingFailed
        case .decodeFailed:
            return MLConstants.errorMessage.jsonDecodingFailed
        }
    }
    var debugDescription: String {
        return "\(String(describing: type(of: self))).\(String(describing: self)) (\(MLConstants.fieldNames.code) \((self as NSError).code))"
    }
}
extension MLError.badAccessInstance:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .forbidden:
            return MLConstants.errorMessage.forbidden
        }
    }
    var debugDescription: String {
        return "\(String(describing: type(of: self))).\(String(describing: self)) (\(MLConstants.fieldNames.code) \((self as NSError).code))"
    }
}
