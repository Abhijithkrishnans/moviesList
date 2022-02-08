//
//  HFAPIWorker+Networking.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 05/02/22.
//

import Foundation
// MARK: Netrworking methods
extension MLWorker {
    //** Define API's to be used here **
    enum API {
        case fetchMoviesList
        case fetchFavoriteList
        case fetchImage(String?)
    }
}
extension MLWorker.API:MLAPICall {
    //** Configure each API attributes based on API enumeration **
    
    var path: String {
        switch self {
        case .fetchMoviesList,.fetchFavoriteList:
            return MLConstants.networking.baseURL
        case .fetchImage(_):
            return MLConstants.networking.singleImagebaseURL
        }
    }
    var method: String {
        switch self {
        case .fetchMoviesList,.fetchFavoriteList,.fetchImage(_):
            return MLConstants.networking.GET
        }
    }
    var headers: [String : String]? {
        switch self {
        case .fetchMoviesList,.fetchFavoriteList,.fetchImage(_):
            return ["Accept":"application/json"]
        }
    }
    var microService:String {
        switch self {
        //** Getting micro service as input **
        case .fetchMoviesList,.fetchFavoriteList:
            return MLConstants.microServices.movies
        case .fetchImage(let endMservice):
            guard let mservice = endMservice else {return MLConstants.fieldNames.empty}
            return mservice
        }
    }
    var microServiceMethod:String {
        switch self {
        //** Getting micro service type as input **
        case .fetchMoviesList:
            return MLConstants.microServices.method.list
        case .fetchFavoriteList:
            return MLConstants.microServices.method.favorites
        case .fetchImage(_):
            return MLConstants.fieldNames.empty
        }
    }
}
extension MLWorker.API{
    // ** Build Request body **
    func body()throws -> Data? {
        switch self {
        case .fetchMoviesList,.fetchFavoriteList,.fetchImage(_):
            return nil
        }
    }
    // ** Build final URL string **
    func buildUrlString() throws -> String {
        switch self {
        case .fetchMoviesList,.fetchFavoriteList:
            return "https://\(path)/\(microService)/\(microServiceMethod)"
        case .fetchImage(_):
            return "https://\(path)\(microService)"
        }

    }
}
