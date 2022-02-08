//
//  MLMovieCell.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 03/02/22.
//

import UIKit
import SDWebImage
class MLMovieCell: UITableViewCell {
    //MARK: Common Properties

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
        bg.layer.cornerRadius = CGFloat(MLConstants.sizeElements.imageViewHeight/2)
        bg.clipsToBounds = true
        return bg
    }()
    fileprivate lazy var movieTitle:UILabel = {
        let bg:UILabel = UILabel()
        bg.textAlignment = .left
        bg.numberOfLines = 0
        bg.textColor = .white
        return bg
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.addArrangedSubview(emptyView)
        sv.addArrangedSubview(movieTitle)
        return sv
    }()
    //MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(favBgView, anchors: [.top(5),.leading(16),.trailing(-16),.bottom(-5),.height(70)])
        favBgView.addSubview(stackView, anchors: [.top(0),.leading(0),.trailing(0),.bottom(0)])
        emptyView.addSubview(favImageView, anchors: [.height(CGFloat(MLConstants.sizeElements.imageViewHeight)),.width(CGFloat(MLConstants.sizeElements.imageViewHeight)),.centerX(0),.centerY(0)])
        emptyView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2).isActive = true
        self.contentView.backgroundColor = .SFBGThemeColor
    }
}

//MARK: Common Helpers
extension MLMovieCell {
    func prepareCell(model: MLMoviesListModel?) {
       bindData(model: model)
    }
    func bindData(model: MLMoviesListModel?){
        movieTitle.text = model?.original_title ?? ""
        favBgView.layer.borderColor = (model?.isSelected ?? false) ? UIColor.SFThemeSelectionColor.cgColor : UIColor.clear.cgColor
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
