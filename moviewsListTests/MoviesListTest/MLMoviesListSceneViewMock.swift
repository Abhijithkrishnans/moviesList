//
//  MLMoviesListSceneViewMock.swift
//  moviewsListTests
//
//  Created by Abhijithkrishnan on 08/02/22.
//

import XCTest
import Combine
@testable import moviewsList
class MLMoviesListSceneViewMock: MLMoviewsListViewProtocol {
    //MARK: Interfaces properties
    var viewModel: MLMoviesListViewModelMock?
    var subscriptions = Set<AnyCancellable>()
    var loadMoviesSubject = PassthroughSubject<Void, Never>()
    var moviesFavorite: [MLMoviesListModel]?
    var moviesAll: [MLMoviesListModel]?
    var selectedList: [MLMoviesListModel]?
    
    ///Convenience properties for checking method invocation
    var exp:XCTestExpectation?
    var selectionExp:XCTestExpectation?
    var calledMethods = [CalledMethods]()
    init(){}
}
extension MLMoviesListSceneViewMock {
    //MARK: Mocking data Fetching
    func initiate(endpoint: MLWorker.API) {
        calledMethods.append(.initiate)
        ///Set listener for master movies list table view
        viewModel?.attachViewEventListener(endpoint: endpoint, loadData: loadMoviesSubject.eraseToAnyPublisher())
        
        ///Binding Master Data
        viewModel?.reloadMoviesList
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] resu in
                self?.getFavorite()///Fetching Favorites
                self?.exp?.fulfill()
            },
            receiveValue: { [weak self] (Result) in
                self?.exp?.fulfill()
            })
        .store(in: &subscriptions)
        ///Initiating  data fetch
        loadMoviesSubject.send()
        
        bindDataSource()
    }
    //MARK: Mocking data binding
    func bindDataSource () {
        calledMethods.append(.bindDataSource)
        ///Feeding master data source
        viewModel?.$moviesList.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] items in
            self?.moviesAll = items
           })
           .store(in: &subscriptions)
        ///Feeding favorite data source
        viewModel?.$favoriteList.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] items in
            self?.moviesFavorite = items
           })
           .store(in: &subscriptions)
        
        viewModel?.$selectedList.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] items in
            print(items)
            self?.selectionExp?.fulfill()
            self?.selectedList = items
           })
           .store(in: &subscriptions)
    }
    ///Fetching favorite movies List
    func getFavorite(){
        guard let VM = self.viewModel else {
            return
        }
        if VM.favoriteList.isEmpty {
            calledMethods.append(.getFavorite)
            VM.attachViewEventListener(endpoint: .fetchFavoriteList, loadData: loadMoviesSubject.eraseToAnyPublisher())
            loadMoviesSubject.send()
        }
    }
    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case initiate
        case bindDataSource
        case getFavorite
        static func == (lhs:MLMoviesListSceneViewMock.CalledMethods, rhs:MLMoviesListSceneViewMock.CalledMethods) -> Bool {
            switch (lhs,rhs) {
            case (.initiate, .initiate),
                 (.bindDataSource, .bindDataSource),
                (.getFavorite, .getFavorite):
                return true
            default:
                return false
            }
        }
    }
}
extension MLMoviesListSceneViewMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}

