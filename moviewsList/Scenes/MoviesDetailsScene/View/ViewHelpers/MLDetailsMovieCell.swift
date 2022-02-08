//
//  MoviesDetailsCell.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 07/02/22.
//

import UIKit

class MLDetailsMovieCell: UITableViewCell {
    //MARK: Common Properties
    
    //MARK: UIControls declarations
    fileprivate let favBgView:UIView = {
        let bg:UIView = UIView()
        return bg
    }()
    
    fileprivate lazy var lblDescription:UILabel = {
        let bg:UILabel = UILabel()
        bg.textAlignment = .left
        bg.numberOfLines = 0
        bg.textColor = .white
        return bg
    }()
    fileprivate lazy var lblRating:UILabel = {
        let bg:UILabel = UILabel()
        bg.textAlignment = .left
        bg.numberOfLines = 0
        bg.textColor = .white
        return bg
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 16
        sv.distribution = .fill
        sv.addArrangedSubview(lblDescription)
        sv.addArrangedSubview(lblRating)
        return sv
    }()
    //MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(favBgView, anchors: [.top(5),.leading(16),.trailing(-16),.bottom(-5)])
        favBgView.addSubview(stackView, anchors: [.top(0),.leading(0),.trailing(0),.bottom(0)])
        
        self.contentView.backgroundColor = .black
    }
}
//MARK: Convenience Initializers
extension MLDetailsMovieCell {
    func prepareCell(model: MLMoviesListModel?) {
       bindData(model)
    }
}
extension MLDetailsMovieCell {
    func bindData(_ model: MLMoviesListModel?) {
        /// Binding Description
        guard let overview = model?.overview else {
            return
        }
        guard let title = model?.original_title else {
            return
        }
        lblDescription.text = "\(title):\n\n\(overview)"
        
        /// Binding Details
        let rating = getRatingString(model)
        let date = getDateString(model)
        let language = getLanguageString(model)
        rating.append(date)
        rating.append(language)
        lblRating.attributedText = rating
    }
    
}
//MARK: Details Binding Helpers
extension MLDetailsMovieCell {
    func getRatingString(_ model: MLMoviesListModel?) -> NSMutableAttributedString {
        let ratingTitle = NSMutableAttributedString(string: "Rating\t",attributes: getAttributes(.white, MLConstants.commonFont.ThemeFontBold, MLConstants.sizeElements.themeDetailsTitilesize))
        guard let rating = model?.rating else {
            return NSMutableAttributedString()
        }
        let ratingValue = String(describing: rating)
        let ratAttrString =  NSAttributedString(string: ratingValue, attributes: getAttributes(.white, MLConstants.commonFont.ThemeFont, MLConstants.sizeElements.themeDetailsValuesize))
        
        ratingTitle.append(ratAttrString)
        ratingTitle.append(NSAttributedString(string: "/10"))
        return ratingTitle
    }
    func getDateString(_ model: MLMoviesListModel?) -> NSMutableAttributedString {
        let dateTitle = NSMutableAttributedString(string: "\nLaunched on\t\t",attributes: getAttributes(.white, MLConstants.commonFont.ThemeFontBold, MLConstants.sizeElements.themeDetailsTitilesize))
        guard let date = model?.release_date else {
            return NSMutableAttributedString()
        }
        let dateValue = date
        let dateAttrString =  NSAttributedString(string: dateValue, attributes: getAttributes(.white, MLConstants.commonFont.ThemeFont, MLConstants.sizeElements.themeDetailsValuesize))
        
        dateTitle.append(dateAttrString)
        return dateTitle
    }
    func getLanguageString(_ model: MLMoviesListModel?) -> NSMutableAttributedString {
        let languageTitle = NSMutableAttributedString(string: "\nLanguage\t",attributes: getAttributes(.white, MLConstants.commonFont.ThemeFontBold, MLConstants.sizeElements.themeDetailsTitilesize))
        guard let language = model?.original_language else {
            return NSMutableAttributedString()
        }
        let languageValue = language
        let languageAttrString =  NSAttributedString(string: languageValue, attributes: getAttributes(.white, MLConstants.commonFont.ThemeFont, MLConstants.sizeElements.themeDetailsValuesize))
        
        languageTitle.append(languageAttrString)
        return languageTitle
    }
    func getAttributes(_ color:UIColor,_ font:String,_ size:CGFloat) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: font, size: size) ?? UIFont()]
    }
}
