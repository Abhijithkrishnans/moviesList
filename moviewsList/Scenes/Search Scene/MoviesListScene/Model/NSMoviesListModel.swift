//
//  NSMoviesListModel.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 03/02/22.
//

import Foundation
//MARK: Data Model Protocols
//Define necessary data model
//protocol MLBaseModelInterface {
//    var results: [MLBaseDataModel]? {get set}
//}
//protocol MLMoviesListModelInterface{
//    var backdrop_path:String? {get set}
//    var id:Int? {get set}
//    var original_language:String? {get set}
//    var original_title:String? {get set}
//    var overview:String? {get set}
//    var popularity:Double? {get set}
//    var poster_path:String? {get set}
//    var release_date:String? {get set}
//    var title:String? {get set}
//    var rating:Int? {get set}
//    var isWatched:Bool? {get set}
//}

//MARK: Data Model Definitions
//Define necessary data model attributes
struct MLBaseDataModel:Codable{
    var results: [MLMoviesListModel]?
}
struct MLMoviesListModel:Codable{
    var backdrop_path: String?
    var id: Int?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: Double?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var rating: Double?
    var isWatched: Bool?
    var isSelected: Bool?
    var isDetails: Bool?
}
