//
//  MLAPIRepoWorker.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 05/02/22.
//

import Foundation
import Combine
//MARK:- Worker protocol
//***Access to worker outside interactor is forbidden***
protocol MLAPIRepoWorker {
    //** Network manager connection requirement
    var networking:MLNetworkingProtocol {get set}
    
    //** Interface used for performing API call for fetching recpies
    func fetchMoviesList(endpoint apiEp:MLWorker.API)-> AnyPublisher<[MLMoviesListModel], Error>
    
}
class MLWorker: NSObject, MLAPIRepoWorker {
    var networking:MLNetworkingProtocol
    init(_ nw:MLNetworkingProtocol) {
        networking = nw
    }
}

//MARK:- Recipie List Methods
extension MLWorker {
    func fetchMoviesList(endpoint apiEp:MLWorker.API) -> AnyPublisher<[MLMoviesListModel], Error> {
    let movies:AnyPublisher<MLBaseDataModel, Error> = networking.call(endPoint: apiEp)
      return movies
            .map {$0.results ?? []}
            .mapError{$0 as Error}
//            .print("Response")
            .eraseToAnyPublisher()
    }
    
}
