//
//  MLDetailsViewModel.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 06/02/22.
//

import Foundation

//MARK: View Model interfaces
protocol MLMovieDetailsProtocol {
    //** Master Data Sources interfaces
    associatedtype moviesDetailsType
    var movie: moviesDetailsType? {get set}
}
class MLDetailsViewModel:MLMovieDetailsProtocol {
    var movie: MLMoviesListModel?
    
    typealias moviesDetailsType = MLMoviesListModel
    ///Initializers
    
}
