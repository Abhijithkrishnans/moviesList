//
//  MLFavoriteMovieCell.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 03/02/22.
//

import UIKit
import SDWebImage
class MLFavoriteMovieCell: UICollectionViewCell {
    //MARK: Common Properties
    var favoriteItem: MLMoviesListModel = MLMoviesListModel()
    
    //MARK: UIControls declarations
    fileprivate lazy var favBgView:UIView = {
        let bg:UIView = UIView()
        bg.backgroundColor = .SFThemeColor
        bg.layer.cornerRadius = 10
        bg.clipsToBounds = true
        bg.layer.borderWidth = 2
        return bg
    }()
    
    fileprivate lazy var emptyView:UIView = {
        let bg:UIView = UIView()
        return bg
    }()
    
    fileprivate lazy var favImageView:UIImageView = {
        let bg:UIImageView = UIImageView()
        bg.backgroundColor = .red
        bg.layer.cornerRadius = 30
        bg.clipsToBounds = true
        return bg
    }()
    fileprivate lazy var favTitle:UILabel = {
        let bg:UILabel = UILabel()
        bg.textAlignment = .center
        bg.numberOfLines = 0
        bg.textColor = .white
        return bg
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.addArrangedSubview(emptyView)
        sv.addArrangedSubview(favTitle)
        return sv
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(favBgView, anchors: [.top(5),.leading(2.5),.trailing(2.5),.bottom(-5)])
        favBgView.addSubview(stackView, anchors: [.top(0),.leading(0),.trailing(0),.bottom(0)])
        emptyView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6).isActive = true
        emptyView.addSubview(favImageView, anchors: [.height(60),.width(60),.centerX(0),.centerY(0)])
    }
}
extension MLFavoriteMovieCell {
    func prepareCell(model: MLMoviesListModel?) {
        favTitle.text = model?.original_title ?? ""
        if model?.isSelected ?? false {
            favBgView.layer.borderColor = UIColor.SFThemeSelectionColor.cgColor
        }else {
            favBgView.layer.borderColor = UIColor.clear.cgColor
        }
        favImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let urlBuilder:URL = URL(string: "https://\(MLConstants.networking.singleImagebaseURL)\(model?.backdrop_path ?? "")") else {
            return
        }
        favImageView.sd_setImage(with:urlBuilder, placeholderImage: UIImage(named: "placeholder"))
    
    }
    
}
