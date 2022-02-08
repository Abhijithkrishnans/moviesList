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
        bg.layer.cornerRadius = MLConstants.sizeElements.commonCornerRadius
        bg.clipsToBounds = true
        bg.layer.borderWidth = MLConstants.sizeElements.commonBorderWidth
        return bg
    }()
    
    fileprivate lazy var emptyView:UIView = {
        let bg:UIView = UIView()
        return bg
    }()
    
    fileprivate lazy var favImageView:UIImageView = {
        let bg:UIImageView = UIImageView()
        bg.layer.cornerRadius = 30
        bg.clipsToBounds = true
        return bg
    }()
    fileprivate lazy var favTitle:UILabel = {
        let bg:UILabel = UILabel()
        bg.textAlignment = .center
        bg.numberOfLines = 0
        bg.textColor = .white
        bg.lineBreakMode = .byWordWrapping
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
    //MARK: Initializers
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

//MARK: Common Helpers
extension MLFavoriteMovieCell {
    func prepareCell(model: MLMoviesListModel?) {
        favTitle.text = model?.original_title ?? MLConstants.fieldNames.empty
        if model?.isSelected ?? false {
            favBgView.layer.borderColor = UIColor.SFThemeSelectionColor.cgColor
        }else {
            favBgView.layer.borderColor = UIColor.clear.cgColor
        }
        favImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let url = buildURL(input: .fetchImage(model?.poster_path)) else {return}
        favImageView.sd_setImage(with:url, placeholderImage: UIImage(named: "placeholder"))
    }
    func buildURL(input:MLWorker.API?) -> URL? {
        var url:URL?
        do{
            guard let urlBuilder:URL = URL(string: try input?.buildUrlString() ?? MLConstants.fieldNames.empty) else {
                return nil
            }
            url = urlBuilder
        }catch{}
        return url
    }
    
    
}
