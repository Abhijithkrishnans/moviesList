//
//  MLMoviesDetailsViewSceneView.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 05/02/22.
//

import UIKit

class MLMoviesDetailsViewSceneView: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeCollectionView()
        let btnCancel = UIButton()
        btnCancel.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        btnCancel.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btnCancel.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)

        //Set Left Bar Button item
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = btnCancel
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    @objc func cancel() {
        self.dismiss(animated: true) {
            print("done")
        }
    }
    private func initializeCollectionView() {
        
        self.view.backgroundColor = .black
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Movies Details"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 31, weight: UIFont.Weight.bold) ]
        self.navigationController?.navigationBar.backgroundColor = .SFThemeColor
        self.navigationController?.navigationBar.barTintColor = .SFThemeColor
        self.navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.view.addSubview(UIView(frame: .zero))
        self.view.addSubview(moviesListMasterTable, anchors: [.top(60),.leading(5),.trailing(-5),.bottom(35)])

    }
}
// MARK: TableView delegates and datasource methods
extension MLMoviesDetailsViewSceneView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        1
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return getFavoriteCell(indexPath, tableView)
        }
        else {
            return getDetailsCell(indexPath, tableView)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        return cell
    }
    //Cell definitions
    private func getDetailsCell(_ indexPath:IndexPath,_ tableView:UITableView) -> MLDetailsMovieCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MLDetailsMovieCell.typeName, for: indexPath) as! MLDetailsMovieCell
        return cell
    }
}
class MLDetailsMovieCell: UITableViewCell {
    //MARK: Common Properties
    
    //MARK: UIControls declarations
    fileprivate let favBgView:UIView = {
        let bg:UIView = UIView()
//        bg.backgroundColor = .SFThemeColor

        return bg
    }()
    
    
    fileprivate lazy var lblDescription:UILabel = {
        let bg:UILabel = UILabel()
        bg.textAlignment = .left
        bg.numberOfLines = 0
        bg.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        bg.textColor = .white
        return bg
    }()
    fileprivate lazy var lblRating:UILabel = {
        let bg:UILabel = UILabel()
        bg.textAlignment = .left
        bg.numberOfLines = 0
        // create attributed string
        let ratingtitleAttribute:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 12)!]
        var ratingTitle = NSMutableAttributedString(string: "Rating\t",attributes: ratingtitleAttribute)
        let rating = "8,7"
        let myAttribute:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Futura", size: 18)!]
        let ratAttrString =  NSAttributedString(string: rating, attributes: myAttribute)
        ratingTitle.append(ratAttrString)
        ratingTitle.append(NSAttributedString(string: "/10"))
        
        let datetitleAttribute:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 12)!]
        let dateTitle = NSAttributedString(string: "\nLaunched on\t",attributes: datetitleAttribute)
        let dateAttribute:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Futura", size: 18)!]
        let dateAttrString =  NSMutableAttributedString(string: "2021-08-11", attributes: dateAttribute)
        ratingTitle.append(dateTitle)
        ratingTitle.append(dateAttrString)
    
        
        let languageTitleAttribute:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 12)!]
        var languageTitle = NSAttributedString(string: "\nLanguage\t",attributes: languageTitleAttribute)
        let languageAttribute:[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Futura", size: 18)!]
        let languageAttrString =  NSAttributedString(string: "En", attributes: languageAttribute)
        ratingTitle.append(languageTitle)
        ratingTitle.append(languageAttrString)
        
        bg.attributedText = ratingTitle
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
