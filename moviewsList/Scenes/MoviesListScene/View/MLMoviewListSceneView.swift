//
//  MLMoviewListSceneView.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 03/02/22.
//

import UIKit
import Combine
import SDWebImage
protocol MLMoviewsListViewProtocol:AnyObject {
    ///Binding Interfaces
    var subscriptions:Set<AnyCancellable> { get set }
    var loadMoviesSubject:PassthroughSubject<Void,Never>{get set}
    associatedtype moviesListType
    var viewModel:moviesListType? {get set}
    
    ///Data Source Interfaces
    var moviesFavorite: [MLMoviesListModel]? { get set }
    var moviesAll: [MLMoviesListModel]? { get set }
    var selectedList: [MLMoviesListModel]? { get set }

}
class MLMoviewListSceneView: UIViewController,MLMoviewsListViewProtocol,UITableViewDelegate,UITableViewDataSource {
    //MARK: Binding Properties
    var subscriptions = Set<AnyCancellable>()
    internal var loadMoviesSubject = PassthroughSubject<Void,Never>()
    var viewModel:MLMoviesListViewModel?
    
    //MARK: Common Properties
    let moviesSections:[moviesSection] = [.FAVORITE,.WATCHED,.TOWATCH]
    
    //MARK: DataSource Properties
    var moviesFavorite: [MLMoviesListModel]?
    var moviesAll: [MLMoviesListModel]?
    var selectedList: [MLMoviesListModel]?
    
    var moviesWatched: [MLMoviesListModel] {
        moviesAll?.filter{$0.isWatched == true} ?? []
    }
    var moviesToWatch: [MLMoviesListModel] {
        moviesAll?.filter{$0.isWatched == false} ?? []
    }
    
    //MARK: UIControls declarations
    ///Define moviews master tableView
    lazy var moviesListMasterTable: UITableView = {
        let tablevw = UITableView(frame: .zero, style: .grouped)
        tablevw.backgroundColor = .black
        tablevw.translatesAutoresizingMaskIntoConstraints = false
        tablevw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tablevw.separatorStyle = .none
        tablevw.dataSource = self
        tablevw.delegate = self
        tablevw.estimatedRowHeight = 125
        //Register required cells below
        tablevw.register(MLMovieCell.self, forCellReuseIdentifier: MLMovieCell.typeName)
        tablevw.register(MLFavoritesCell.self, forCellReuseIdentifier: MLFavoritesCell.typeName)
        tablevw.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.typeName)
        return tablevw
    }()
    ///Define next button
    lazy var btnNext : UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = MLConstants.sizeElements.commonCornerRadius
        btn.clipsToBounds = true
        btn.layer.borderWidth = MLConstants.sizeElements.commonBorderWidth
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.setTitle(MLConstants.fieldNames.Next, for: .normal)
        btn.addAction(UIAction(title: MLConstants.fieldNames.empty, handler: { [weak self] _ in
            self?.pressed()
        }), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCollectionView()
        dataBinding()
    }
}

//MARK: Common Helpers
extension MLMoviewListSceneView {
    ///Initialization for all elements
    private func initializeCollectionView() {
        view.backgroundColor = .SFBGThemeColor
        navigationController?.navigationBar.prefersLargeTitles = true
        title = MLConstants.fieldNames.Movies
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: MLConstants.commonFont.ThemeFont, size: MLConstants.sizeElements.ThemeHeaderTitleSize) ?? 0 ]
        navigationController?.navigationBar.barTintColor = .SFThemeColor
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        ///Embedding UI Elements
        view.addSubview(moviesListMasterTable, anchors: [.top(0),.leading(5),.trailing(-5),.bottom(-80)])
        view.addSubview(btnNext, anchors: [.leading(40), .trailing(-40),.height(40),.bottom(-35)])
        
        view.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge

    }
}
//MARK: Result/Error Handler
extension MLMoviewListSceneView {
    func handleResult(_ result:Result<Void, Error>) {
        view.sd_imageIndicator?.stopAnimatingIndicator()
        switch result {
            case .success():
            break
            case .failure(let error):
            UIAlertController.showAlert(title: MLConstants.errorMessage.badRequest, message: error.localizedDescription, cancelButtonTitle: MLConstants.fieldNames.Ok, otherButtons: [], preferredStyle: .alert, vwController: self) { action, index in
                
            }
            break
        }
    }
}
// MARK: Data Binding
extension MLMoviewListSceneView {
    private func dataBinding() {
        ///Set listener for master movies list table view
        viewModel?.attachViewEventListener(endpoint: .fetchMoviesList, loadData: loadMoviesSubject.eraseToAnyPublisher())
        
        ///Binding Master Data
        viewModel?.reloadMoviesList
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] resu in
                self?.view.sd_imageIndicator?.stopAnimatingIndicator()
                self?.getFavorite()///Fetching Favorites
            },
            receiveValue: { [weak self] (Result) in
                self?.handleResult(Result) ///Error Handling
            })
        .store(in: &subscriptions)
        ///Initiating  data fetch
        loadMoviesSubject.send()
        view.sd_imageIndicator?.startAnimatingIndicator()
        ///Feeding Button State
        bindNextButton()
        ///Feeding DataSources
        bindDataSource()
        
    }
    
    func bindNextButton() {
        ///Binding Next button state
        viewModel?.$isMovieSelected.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: btnNext)
            .store(in: &subscriptions)
        
        ///Configure Next button based on state
        btnNext.publisher(for: \.isEnabled).sink {[unowned self] toggle in
            self.btnNext.backgroundColor = toggle ? .SFThemeSelectionColor : .lightGray }
            .store(in: &subscriptions)
        ///Feeding master data source
        viewModel?.$selectedList.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] items in
               self?.selectedList = items
           })
           .store(in: &subscriptions)
    }
    func bindDataSource () {
        ///Feeding master data source
        viewModel?.$moviesList.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] items in
               self?.moviesAll = items
           })
           .store(in: &subscriptions)
        ///Feeding favorite data source
        viewModel?.$favoriteList.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in
               self?.moviesFavorite = items
               self?.moviesListMasterTable.reloadData()
           })
           .store(in: &subscriptions)
    }
    ///Fetching favorite movies List
    func getFavorite(){
        guard let VM = self.viewModel else {
            return
        }
        if VM.favoriteList.isEmpty {
            VM.attachViewEventListener(endpoint: .fetchFavoriteList, loadData: loadMoviesSubject.eraseToAnyPublisher())
            loadMoviesSubject.send()
        }
    }
}

// MARK: Routing
extension MLMoviewListSceneView {
     func pressed() {
        guard let vm = viewModel else {
            return
        }
        let detailsVc =  vm.prepareMoviesDetailsView(selectedList)
        self.present(UINavigationController(rootViewController: detailsVc), animated: true, completion: nil)
    }
}
// MARK: TableView delegates and datasource methods
extension MLMoviewListSceneView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section:moviesSection = moviesSection(rawValue: section) ?? .NA
        switch section {
        case .FAVORITE:
            return 1
        case .WATCHED:
            return moviesWatched.count
        case .TOWATCH:
            return moviesToWatch.count
        default:
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        moviesSections.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
     }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let section:moviesSection = moviesSection(rawValue: section) ?? .NA
        switch section {
        case .FAVORITE:
            return MLConstants.fieldNames.Favorite
        case .WATCHED:
            return MLConstants.fieldNames.Watched
        case .TOWATCH:
            return MLConstants.fieldNames.ToWatch
        default:
            return MLConstants.fieldNames.empty
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.font = UIFont(name: MLConstants.commonFont.ThemeFont, size: MLConstants.sizeElements.ThemeSectionHeaderTitleSize)
        header.textLabel?.textColor = .white
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section:moviesSection = moviesSection(rawValue: indexPath.section) ?? .NA
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.typeName, for: indexPath)
        switch section {
        case .FAVORITE:
            return getFavoriteCell(indexPath, tableView)
        case .WATCHED:
            return getMoviesCell(indexPath, tableView, moviesWatched)
        case .TOWATCH:
            return getMoviesCell(indexPath, tableView, moviesToWatch)
        default:
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section:moviesSection = moviesSection(rawValue: indexPath.section) ?? .NA
        switch section {
        case .WATCHED:
            setSelection(moviesWatched[indexPath.row], isFavorite: false)
            break
        case .TOWATCH:
            setSelection(moviesToWatch[indexPath.row], isFavorite: false)
            break
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
//MARK: TableView Helper
extension MLMoviewListSceneView {
    //Cell definitions
    private func getFavoriteCell(_ indexPath:IndexPath,_ tableView:UITableView) -> MLFavoritesCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MLFavoritesCell.typeName, for: indexPath) as! MLFavoritesCell
        cell.completion = { [unowned self] model in
            setSelection(model, isFavorite: true)
        }
        cell.prepareCell(FavoriteList: moviesFavorite)
        return cell
    }
    func setSelection(_ model:MLMoviesListModel?, isFavorite:Bool){
        viewModel?.setSelection(model,isFavorite: isFavorite)
        self.moviesListMasterTable.reloadData()
    }
    private func getMoviesCell(_ indexPath:IndexPath,_ tableView:UITableView,_ dataSource:[MLMoviesListModel] ) -> MLMovieCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MLMovieCell.typeName, for: indexPath) as! MLMovieCell
        cell.prepareCell(model: dataSource[indexPath.row])
        return cell
    }
}

extension MLMoviewListSceneView {
    enum moviesSection:Int {
        case FAVORITE = 0
        case WATCHED = 1
        case TOWATCH = 2
        case NA = 3
    }
}
