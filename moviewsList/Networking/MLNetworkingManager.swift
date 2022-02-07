//
//  MLNetworkingManager.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 02/02/22.
//

import Foundation
import Combine
protocol MLNetworkingProtocol {
    func call<T: Decodable>(endPoint:MLAPICall) -> AnyPublisher<T, Error>
}
class MLNetworking:MLNetworkingProtocol{
    func call<T: Decodable>(endPoint:MLAPICall) -> AnyPublisher<T, Error> {
        if Reachability.isConnectedToNetwork() {
        do{
            let url = try endPoint.buildUrlString()
            let request = try endPoint.urlRequest(baseURL: url)
            let session = endPoint.configuration()
            return session.dataTaskPublisher(for: request)
                .retry(1)
                .mapError{$0 as Error}
                .map { $0.0 }
                .decode(type: T.self, decoder: JSONDecoder())
                .catch { error in
                    Fail(error: error).eraseToAnyPublisher() }
                .eraseToAnyPublisher()
        }catch{
            return Fail(error: MLError.requestBuildFailure.urlCreationFailed).eraseToAnyPublisher()
        }
        }else{
            return Fail(error: MLError.apiFailure.connectivityError).eraseToAnyPublisher()
        }
    }
    
}
