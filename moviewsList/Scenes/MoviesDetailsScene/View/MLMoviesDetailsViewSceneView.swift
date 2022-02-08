//
//  MLMoviesDetailsViewSceneView.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 05/02/22.
//

import UIKit
import Combine
protocol MLMoviewsDetailsViewProtocol:AnyObject {
    ///Binding Interfaces
    var subscriptions:Set<AnyCancellable> { get set }
    var loadDetailsSubject:PassthroughSubject<Void,Never>{get set}
    var viewModel:MLDetailsViewModel? {get set}
    
    ///Data Source Interfaces
    associatedtype moviesListType
    var moviesList: [moviesListType]? { get set }
}
class MLMoviesDetailsViewSceneView: UIViewController,MLMoviewsDetailsViewProtocol {
    
    //MARK: Binding Properties
    var subscriptions = Set<AnyCancellable>()
    internal var loadDetailsSubject = PassthroughSubject<Void,Never>()
    var viewModel:MLDetailsViewModel?
    
    //MARK: Common Properties
    var detailsSections:[detailsSection] = [.POSTER,.DETAILS]
    var moviesList: [moviesListType]?
    typealias moviesListType = MLMoviesListModel
    
    //MARK: UIControls declarations
    //Define TableView
    lazy var moviesListMasterTable: UITableView = {
        let tablevw = UITableView(frame: .zero)
        tablevw.backgroundColor = .black
        tablevw.translatesAutoresizingMaskIntoConstraints = false
        tablevw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tablevw.separatorStyle = .none
        tablevw.dataSource = self
        tablevw.delegate = self
        tablevw.estimatedRowHeight = 125
        //Register required cells below
        tablevw.register(MLDetailsMovieCell.self, forCellReuseIdentifier: MLDetailsMovieCell.typeName)
        tablevw.register(MLFavoritesCell.self, forCellReuseIdentifier: MLFavoritesCell.typeName)
        tablevw.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.typeName)
        return tablevw
    }()
    ///Define next button
    lazy var btnclose : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btn.addAction(UIAction(title: MLConstants.fieldNames.empty, handler: { [weak self] _ in
            self?.cancel()
        }), for: .touchUpInside)
        return btn
    }()
    ///Define next button
    lazy var barButton : UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.customView = self.btnclose
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeCollectionView()

        //Set Left Bar Button item
        self.navigationItem.leftBarButtonItem = barButton
    }
    private func initializeCollectionView() {
        
        view.backgroundColor = .SFBGThemeColor
        navigationController?.isNavigationBarHidden = false
        title = "Movie Details"
        navigationController?.navigationBar.backgroundColor = .SFThemeColor
        navigationController?.navigationBar.barTintColor = .SFThemeColor
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: MLConstants.commonFont.ThemeFont, size: MLConstants.sizeElements.ThemeSectionHeaderTitleSize) ?? 0]
        
        ///Embedding UI Elements
        view.addSubview(UIView(frame: .zero))///Base Containerview
        view.addSubview(moviesListMasterTable, anchors: [.top(60),.leading(5),.trailing(-5),.bottom(35)])
        
        ///Feeding master data source
        viewModel?.$movieslist.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] items in
            self?.moviesList = items
            self?.moviesListMasterTable.reloadData()
           })
           .store(in: &subscriptions)

    }
}

//MARK: UIAction Handlers
extension MLMoviesDetailsViewSceneView {
    func cancel() {
        self.dismiss(animated: true) {
        }
    }
}
// MARK: TableView delegates and datasource methods
extension MLMoviesDetailsViewSceneView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        detailsSections.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section:detailsSection = detailsSection(rawValue: indexPath.row) ?? .NA
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.typeName, for: indexPath)
        switch section {
        case .POSTER:
            return getFavoriteCell(indexPath, tableView)
        case .DETAILS:
            return getDetailsCell(indexPath, tableView)
        default:
            return cell
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
//MARK: TableView Helper
extension MLMoviesDetailsViewSceneView {
    //Cell definitions
    private func getFavoriteCell(_ indexPath:IndexPath,_ tableView:UITableView) -> MLFavoritesCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MLFavoritesCell.typeName, for: indexPath) as! MLFavoritesCell
        cell.prepareCell(FavoriteList: moviesList)
        return cell
    }
    private func getDetailsCell(_ indexPath:IndexPath,_ tableView:UITableView) -> MLDetailsMovieCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MLDetailsMovieCell.typeName, for: indexPath) as! MLDetailsMovieCell
        cell.prepareCell(model: moviesList?.first)
        return cell
    }
}
extension MLMoviesDetailsViewSceneView {
    enum detailsSection:Int {
        case POSTER = 0
        case DETAILS = 1
        case NA = 3
    }
}
