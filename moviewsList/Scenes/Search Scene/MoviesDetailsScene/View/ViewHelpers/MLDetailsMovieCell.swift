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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(favBgView, anchors: [.top(5),.leading(16),.trailing(-16),.bottom(-5)])
        favBgView.addSubview(stackView, anchors: [.top(0),.leading(0),.trailing(0),.bottom(0)])
        
        self.contentView.backgroundColor = .black
        bindData()
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
extension MLDetailsMovieCell {
    func bindData() {
        // create attributed string
        let ratingTitle = NSMutableAttributedString(string: "Rating\t",attributes: getAttributes(.white, "Futura-Bold", 12))
        let ratingValue = "8,7"
        let ratAttrString =  NSAttributedString(string: ratingValue, attributes: getAttributes(.white, "Futura", 18))
        
        ratingTitle.append(ratAttrString)
        ratingTitle.append(NSAttributedString(string: "/10"))
        
        let datetitleAttribute:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 12)!]
        let dateTitle = NSAttributedString(string: "\nLaunched on\t\t",attributes: datetitleAttribute)
        let dateAttribute:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Futura", size: 18)!]
        let dateAttrString =  NSMutableAttributedString(string: "2021-08-11", attributes: dateAttribute)
        ratingTitle.append(dateTitle)
        ratingTitle.append(dateAttrString)
    
        
        let languageTitleAttribute:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 12)!]
        var languageTitle = NSAttributedString(string: "\nLanguage\t",attributes: languageTitleAttribute)
        let languageAttribute:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Futura", size: 18)!]
        let languageAttrString =  NSAttributedString(string: "En", attributes: languageAttribute)
        ratingTitle.append(languageTitle)
        ratingTitle.append(languageAttrString)
        
        lblRating.attributedText = ratingTitle
    }
    func getAttributes(_ color:UIColor,_ font:String,_ size:CGFloat) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: font, size: 18)!]
    }
}
extension MLMoviesDetailsViewSceneView {
    enum detailsSection:Int {
        case POSTER = 0
        case DETAILS = 1
        case NA = 3
    }
}
