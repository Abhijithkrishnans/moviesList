//
//  MoviesWorkerMock.swift
//  moviewsListTests
//
//  Created by Abhijithkrishnan on 08/02/22.
//

import XCTest
import Combine
@testable import moviewsList
class MoviesWorkerMock: MLAPIRepoWorker {
    var networking: MLNetworkingProtocol
    
    required init(_ nw:MLNetworkingProtocol) {
        networking = nw
    }
    func decodeDataModel<T :Decodable>(endpoint apiEp:MLWorker.API) -> AnyPublisher<T, Error> {
        ///Fetching Mock Data from Json
        var mockData = Data()
        switch apiEp {
        case .fetchMoviesList:
            guard let data = MLUtilities.getDataFromBundle(WithName: "MoviesListMock", ext: "json") else {
                return Fail(error: MLError.requestBuildFailure.urlCreationFailed).eraseToAnyPublisher()
            }
            mockData = data
            break
        case .fetchFavoriteList:
            guard let data = MLUtilities.getDataFromBundle(WithName: "MoviesListMock", ext: "json") else {
                return Fail(error: MLError.requestBuildFailure.urlCreationFailed).eraseToAnyPublisher()
            }
            mockData = data
        default:
            break
        }
        
        ///Decode and return expected model
        return Just(mockData)
                .map {$0}
                .decode(type: T.self, decoder: JSONDecoder())
                .catch { error in
                    Fail(error: error).eraseToAnyPublisher() }
                .eraseToAnyPublisher()
    }
    func fetchMoviesList(endpoint apiEp:MLWorker.API) -> AnyPublisher<[MLMoviesListModel], Error> {
        let movies:AnyPublisher<MLBaseDataModel, Error> = decodeDataModel(endpoint: apiEp)
          return movies
                .map {$0.results ?? []}
                .mapError{$0 as Error}
                .eraseToAnyPublisher()
    }
}
