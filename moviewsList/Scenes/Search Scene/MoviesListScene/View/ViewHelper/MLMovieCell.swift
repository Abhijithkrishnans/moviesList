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
        bg.layer.cornerRadius = 25
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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(favBgView, anchors: [.top(5),.leading(16),.trailing(-16),.bottom(-5),.height(70)])
        favBgView.addSubview(stackView, anchors: [.top(0),.leading(0),.trailing(0),.bottom(0)])
        emptyView.addSubview(favImageView, anchors: [.height(50),.width(50),.centerX(0),.centerY(0)])
        emptyView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2).isActive = true
        self.contentView.backgroundColor = .black
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension MLMovieCell {
    func prepareCell(model: MLMoviesListModel?) {
       bindData(model: model)
    }
    func bindData(model: MLMoviesListModel?){
        movieTitle.text = model?.original_title ?? ""
        favBgView.layer.borderColor = (model?.isSelected ?? false) ? UIColor.SFThemeSelectionColor.cgColor : UIColor.clear.cgColor
        favImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let url = buildURL(inputStr: model?.backdrop_path) else {
            return
        }
        favImageView.sd_setImage(with:url, placeholderImage: UIImage(named: "placeholder"))
    }
    func buildURL(inputStr:String?) -> URL? {
        guard let urlBuilder:URL = URL(string: "https://\(MLConstants.networking.singleImagebaseURL)\(inputStr ?? "")") else {
            return nil
        }
        return urlBuilder
    }
}
