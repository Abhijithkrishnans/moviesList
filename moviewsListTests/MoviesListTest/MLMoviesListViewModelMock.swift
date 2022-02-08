//
//  MLMoviesListViewModelMock.swift
//  moviewsListTests
//
//  Created by Abhijithkrishnan on 08/02/22.
//

import XCTest
import Combine
@testable import moviewsList
class MLMoviesListViewModelMock: MLMoviesListProtocol {
    //MARK: Interface Properties
    var dataManager: MLAPIRepoWorker
    var subscriptions = Set<AnyCancellable>()
    var loadData: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    
    @Published var moviesList = [MLMoviesListModel]()
    @Published var favoriteList = [MLMoviesListModel]()
    @Published var selectedList = [MLMoviesListModel]()
    
    typealias moviesListType = MLMoviesListModel
    
    var reloadMoviesList: AnyPublisher<Result<Void, Error>, Never> {
        reloadMoviesListSubject.eraseToAnyPublisher()
    }
    private let reloadMoviesListSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    required init(_ datamanager: MLAPIRepoWorker) {
        dataManager = datamanager
    }
}
extension MLMoviesListViewModelMock {
    func setSelection(_ model: MLMoviesListModel?, isFavorite: Bool) {
        guard let dataModel = model else {
            return
        }
        self.moviesList = self.moviesList.compactMap{ mov -> MLMoviesListModel in
            var movobj = mov
            if dataModel.id == movobj.id {
                movobj.isSelected?.toggle()
            }else {
                movobj.isSelected = false
            }
            return movobj
        }
        self.selectedList = self.moviesList.filter{$0.isSelected == true}
        /// Reloading Datasources
        self.moviesList = getSortedList(movies: self.moviesList)
        self.extrackFavoriteList(favlist: self.favoriteList)
    }
    
    func attachViewEventListener(endpoint: MLWorker.API, loadData: AnyPublisher<Void, Never>) {
        self.loadData = loadData
        self.loadData
            .setFailureType(to: Error.self)
            .flatMap{[weak self] _ -> AnyPublisher<[MLMoviesListModel],Error> in
                guard let weakSelf = self else {
                    return Fail(error: MLError.badAccessInstance.forbidden).eraseToAnyPublisher()
                }
                return weakSelf.dataManager.fetchMoviesList(endpoint: endpoint)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                switch completion {
                case .finished:
                    self?.reloadMoviesListSubject.send(completion: .finished) /// Final Feedback to View
                    break
                case .failure(let error):
                    self?.reloadMoviesListSubject.send(.failure(error))
                    break
                }
            },
              receiveValue: { [weak self] movies in
                
                self?.resultsHandler(endpoint: endpoint, results: movies) /// Final Feedback to View
            })
            .store(in: &subscriptions)
    }
    private func injectSelectionProperty(){
        self.moviesList = self.moviesList.compactMap{ movie in
            var movobj = movie
            movobj.isSelected = false
            return movobj
        }
    }
    private func resultsHandler(endpoint ep:MLWorker.API, results:[MLMoviesListModel]) {
        switch ep {
        case .fetchMoviesList:
            moviesList.removeAll() /// Ensuring the array has cleared
            moviesList.append(contentsOf: getSortedList(movies: results)) /// Loading datasource
            injectSelectionProperty() /// Injecting convenience property for selection handling
            self.reloadMoviesListSubject.send(completion:.finished) /// Feedback to View
            break
        case .fetchFavoriteList:
            self.extrackFavoriteList(favlist: results) /// Bifurcating Favorite list from master
            self.reloadMoviesListSubject.send(completion: .finished) /// Final Feedback to View
            break
        default:
            break
        }
    }
    private func extrackFavoriteList(favlist:[MLMoviesListModel]) {
        self.favoriteList = getSortedList(movies: moviesList.filter{ (mov) in
            favlist.contains(where: { $0.id == mov.id ?? 0 })
        })
    }
    
    private func getSortedList(movies list:[MLMoviesListModel]) -> [MLMoviesListModel] {
        /// Sort with multiple criteria
        /// Primary: Rating
        /// Secondary: Name/Title
        list.sorted{c1,c2 in
            if c1.rating != c2.rating {
                return c1.rating ?? 0.0 > c2.rating ?? 0.0
            }else {
                return c1.title ?? "" > c2.title ?? ""
            }
        }
    }
}
