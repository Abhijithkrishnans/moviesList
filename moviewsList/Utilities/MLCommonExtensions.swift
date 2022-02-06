//
//  MLCommonExtensions.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 02/02/22.
//

import Foundation
import UIKit
//MARK: Color Extensions
extension UIColor {
    static let SFThemeColor = UIColor(red: 41/255.0, green: 43/255.0, blue: 54/255.0, alpha: 1.0)
    static let SFBGThemeColor = UIColor.black
    static let SFThemeComponentColor = UIColor(red: 0/255.0, green: 77/255.0, blue: 34/255.0, alpha: 1.0)
    static let SFThemeSelectionColor = UIColor(red: 114/255.0, green: 188/255.0, blue: 212/255.0, alpha: 1.0)
}

//MARK: View Extensions
extension UIView {
    func roundCornersWithRadius(_ radius:CGFloat, corners:CACornerMask) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    func addShadow(_ color:CGColor? = nil,_ opacity:Float = 0.0,_ offset:CGSize = .zero,_ radius:CGFloat = 0.0){
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
    static var typeName: String {
           return String(describing: self)
   }
}
//MARK: ALERT EXTENSIONS
extension UIAlertController {
   static func showAlert(title:String, message:String,cancelButtonTitle:String,otherButtons:NSArray, preferredStyle:UIAlertController.Style, vwController:UIViewController, completion: @escaping (_ action: UIAlertAction,_ index:Int) -> Void)    {
        var clickedIndex:Int = 0
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alertController.addAction(UIAlertAction(title:cancelButtonTitle, style: .cancel, handler:{ action in
            DispatchQueue.main.async {
                completion(action,0)
            }
        }))
        for title in otherButtons{
            clickedIndex+=1
            alertController.view.tag = clickedIndex;
            let singleButton = UIAlertAction(title: title as? String, style: .default, handler:{ action in
                DispatchQueue.main.async {
                    completion(action,alertController.actions.firstIndex(of: action) ?? 0)
                    
                }
            })
            alertController.addAction(singleButton)
        }
        DispatchQueue.main.async {
            vwController.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}
