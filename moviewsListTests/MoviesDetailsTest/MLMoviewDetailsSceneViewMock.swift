//
//  MLMoviewDetailsSceneViewMock.swift
//  moviewsListTests
//
//  Created by Abhijithkrishnan on 08/02/22.
//

import Combine
import XCTest
@testable import moviewsList
class MLMoviewDetailsSceneViewMock: MLMoviewsDetailsViewProtocol {
    var subscriptions = Set<AnyCancellable>()
    
    var loadDetailsSubject = PassthroughSubject<Void, Never>()
    
    var viewModel: MLMovieDetailsMock?
    
    var moviesList: [MLMoviesListModel]?
    
    typealias moviesListType = MLMoviesListModel
    
    var exp:XCTestExpectation?
    var calledMethods = [CalledMethods]()
    
    func initiate(){
        ///Feeding master data source
        viewModel?.$movieslist.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] items in
            self?.moviesList = items
            self?.exp?.fulfill()
           })
           .store(in: &subscriptions)
    }
    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case initiate
        case bindDataSource
        case getFavorite
        static func == (lhs:MLMoviewDetailsSceneViewMock.CalledMethods, rhs:MLMoviewDetailsSceneViewMock.CalledMethods) -> Bool {
            switch (lhs,rhs) {
            case (.initiate, .initiate):
                return true
            default:
                return false
            }
        }
    }
}
extension MLMoviewDetailsSceneViewMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}

