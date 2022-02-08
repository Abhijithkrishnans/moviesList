//
//  MLMovieDetailsMock.swift
//  moviewsListTests
//
//  Created by Abhijithkrishnan on 08/02/22.
//

import Combine
@testable import moviewsList
class MLMovieDetailsMock:MLMovieDetailsProtocol {
    @Published var movieslist: [MLMoviesListModel]?
    typealias moviesDetailsType = MLMoviesListModel
    
    required init(_ moviesList: [MLMoviesListModel]?) {
        self.movieslist = moviesList?.compactMap{ mov -> MLMoviesListModel in
            var movobj = mov
            movobj.isDetails = true
            return movobj
        }
    }
}
