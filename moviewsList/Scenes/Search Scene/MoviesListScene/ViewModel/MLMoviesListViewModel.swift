//
//  MLMoviesListViewModel.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 03/02/22.
//

import UIKit
import Combine


//MARK: View Model interfaces
protocol MLMoviesListProtocol {
    //** Listener Interface
    func attachViewEventListener(endpoint:MLWorker.API, loadData: AnyPublisher<Void, Never>)
    
    //** Master Data Sources interfaces
    associatedtype moviesListType
    var moviesList: [moviesListType]{get set}
    var favoriteList: [moviesListType]{get set}
    
    //** View Model connection to expose the fetched results to pipeline **
    var dataManager: MLAPIRepoWorker { get set }
    
    func setSelection(_ model:MLMoviesListModel?, isFavorite:Bool)
    
}
class MLMoviesListViewModel: MLMoviesListProtocol {
    ///Property Interfaces
    typealias moviesListType = MLMoviesListModel
    var dataManager: MLAPIRepoWorker
    
    ///Contain all subscriptions
    private var subscriptions = Set<AnyCancellable>()
    
    ///Data source for the Movies List table view.
    @Published var moviesList: [moviesListType] = [moviesListType]()
    @Published var favoriteList: [moviesListType] = [moviesListType]()
    @Published var selectedList: [moviesListType] = [moviesListType]()
    
    // MARK: Input
    private var loadData: AnyPublisher<Void, Never> = PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    
    // MARK: Output
    @Published var isMovieSelected: Bool = false
    var reloadMoviesList: AnyPublisher<Result<Void, Error>, Never> {
        reloadMoviesListSubject.eraseToAnyPublisher()
    }
    private let reloadMoviesListSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    ///Initializers
    init(_ datamanager:MLAPIRepoWorker) {
        dataManager = datamanager
    }
}

//MARK: API CALL
extension MLMoviesListViewModel {
    //Attaching listener
    func attachViewEventListener(endpoint:MLWorker.API, loadData: AnyPublisher<Void, Never>) {
        self.loadData = loadData
        self.loadData
            .setFailureType(to: Error.self)
            .flatMap{[weak self] _ -> AnyPublisher<[MLMoviesListModel],Error> in
                guard let weakSelf = self else {
                    return Fail(error: MLError.badAccessInstance.forbidden).eraseToAnyPublisher()
                }
                return weakSelf.fetchDataWith(endPoint: endpoint)
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
                self?.resultsHandler(endpoint: endpoint, results: movies)
            })
            .store(in: &subscriptions)
    }
}

//MARK: Common Helper
extension MLMoviesListViewModel {
    private func clearMasterMovieList() {
        self.moviesList.removeAll()
    }
    private func clearMasterFavList() {
        self.favoriteList.removeAll()
    }
    private func fetchDataWith(endPoint ep:MLWorker.API) -> AnyPublisher<[MLMoviesListModel], Error> {
       return dataManager.fetchMoviesList(endpoint: ep)
    }
    private func resultsHandler(endpoint ep:MLWorker.API, results:[MLMoviesListModel]) {
        switch ep {
        case .fetchMoviesList:
            clearMasterMovieList() /// Ensuring the array has cleared
            moviesList.append(contentsOf: getSortedList(movies: results)) /// Loading datasource
            injectSelectionProperty() /// Injecting convenience property for selection handling
            self.reloadMoviesListSubject.send(completion:.finished) /// Feedback to View
            break
        case .fetchFavoriteList:
            self.extrackFavoriteList(favlist: results) /// Bifurcating Favorite list from master
            self.reloadMoviesListSubject.send(completion: .finished) /// Final Feedback to View
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
    private func injectSelectionProperty(){
        self.moviesList = self.moviesList.compactMap{ movie in
            var movobj = movie
            movobj.isSelected = false
            return movobj
        }
    }
}
//MARK: Cell Data Binding Helper 
extension MLMoviesListViewModel {
    func setSelection(_ model:MLMoviesListModel?, isFavorite:Bool){
        guard let dataModel = model else {
            return
        }
        self.moviesList = self.moviesList.compactMap{ mov -> MLMoviesListModel in
            var movobj = mov
            if dataModel.id == movobj.id {
                movobj.isSelected?.toggle()
                isMovieSelected = movobj.isSelected ?? false
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
}


extension MLMoviesListViewModel {
    func prepareMoviesDetailsView(_ selectedList:[MLMoviesListModel]?) -> UIViewController {
        return DIContainer.bootstrapMoviesDetailsView(selectedList) as UIViewController
    }
}
