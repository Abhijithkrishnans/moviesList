//
//  MLFavoritesCell.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 03/02/22.
//

import UIKit
import Combine
class MLFavoritesCell: UITableViewCell {
    //MARK: Common Properties
    var moviesFavorites: [MLMoviesListModel]?
    //MARK: UIControls declarations
    //Define CollectionView
    lazy var flowLayout:UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize(width: 120, height: 150)
        layout.scrollDirection = .horizontal
       return layout
   }()
   lazy var moviesFavList: UICollectionView = {
       let cv = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
       cv.translatesAutoresizingMaskIntoConstraints = false
       cv.setCollectionViewLayout(self.flowLayout, animated: true)
       cv.dataSource = self
       cv.delegate = self
       cv.backgroundColor = .black
       cv.register(MLFavoriteMovieCell.self, forCellWithReuseIdentifier: MLFavoriteMovieCell.typeName)
       return cv
   }()
    // Events
    var cellSelected: AnyPublisher<IndexPath, Never> {
        favoriteCellSelectedSubject.eraseToAnyPublisher()
    }
    private var favoriteCellSelectedSubject = PassthroughSubject<IndexPath, Never>()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeView()
    }
    var completion : ((MLMoviesListModel?) -> Void)?
    
}
//MARK: Initializers
extension MLFavoritesCell {
    //Initialization for all elements
    private func initializeView() {
        self.contentView.addSubview(moviesFavList, anchors: [.top(0),.leading(0),.trailing(0),.height(150),.bottom(0)])
    }
    func prepareCell(FavoriteList: [MLMoviesListModel]?) {
        self.moviesFavorites = FavoriteList
        moviesFavList.reloadData()
    }
}
//MARK: Common Helpers
extension MLFavoritesCell {

}
// MARK: Collection delegates and datasource methods
extension MLFavoritesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesFavorites?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getFavoriteCell(indexPath, collectionView)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        let totalCellWidth = 90 * collectionView.numberOfItems(inSection: 0)
//        let totalSpacingWidth = 5 * (collectionView.numberOfItems(inSection: 0) - 1)
//
//        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        favoriteCellSelectedSubject.send(indexPath)
        print("Selectedindex\(indexPath.item)")
        completion?(moviesFavorites?[indexPath.item])
    }
}
//MARK: CollectionView Helper
extension MLFavoritesCell {
    private func getFavoriteCell(_ indexPath:IndexPath,_ collectionView:UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MLFavoriteMovieCell.typeName, for: indexPath) as! MLFavoriteMovieCell
        cell.prepareCell(model: moviesFavorites?[indexPath.item])
        
        return cell
    }
}