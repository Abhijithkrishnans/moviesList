//
//  NSMoviesListModel.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 03/02/22.
//

import Foundation

//MARK: Data Model Definitions
///Define necessary data model attributes
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
    var isSelected: Bool?///Convenience property used for selection handling
    var isDetails: Bool?///Convenience property usied for screen differentiation
}
