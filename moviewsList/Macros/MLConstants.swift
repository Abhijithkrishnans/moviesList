//
//  MLConstants.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 02/02/22.
//

import Foundation
import UIKit

enum MLConstants {
    enum networking {
        static let baseURL = "61efc467732d93001778e5ac.mockapi.io"
        static let singleImagebaseURL = "image.tmdb.org/t/p/w500/"
        static let GET = "GET"
        static let POST = "POST"
        static let json = "json"
        static let XML = "XML"
    }
    
    enum microServices {
        static let movies = "movies"
        enum method{
            static let list = "list"
            static let favorites = "favorites"
        }
    }
    enum commonSize {
        
    }
    enum commonFont {
        static let ThemeFont = "Futura"
        static let ThemeFontBold = "Futura-Bold"
    }
    enum fieldNames {
        static let NA = "NA"
        static let code = "code"
        static let Ok = "Ok"
        static let empty = ""
        static let Next = "Next"
        static let Movies = "Movies"
        static let Favorite = "Favorite"
        static let ToWatch = "Towatch"
        static let Watched = "Watched"
    }
    enum screenTitle {
        static let HomeTitle = "Find Images"
        static let searchBarPlaceHolder = "Search here for your favourite image"
        static let resetButtonTitle = "Reset Search"
    }
    enum errorMessage {
        static let endPointFailed = "End point authentication failed."
        static let noData = "Response returned with no data to decode."
        static let badRequest = "Bad request."
        static let outdated = "The url you requested is outdated."
        static let networkRequestFailed = "Network request failed."
        static let parseError = "Unable to parse response."
        static let nilParam = "Parameters were nil."
        static let urlRequestFailed = "Unable to create request URL"
        static let jsonEncodingFailed = "Json encoding failed."
        static let jsonDecodingFailed = "We could not decode the response."
        static let forbidden = "Unable to access current instance"
        static let connectivityError = "No Internet Connection. Please connect to internet and press Ok to try again."
        static let undefinedInput = "Input model can't be null"
    }
    enum sizeElements {
        static let commonCornerRadius:CGFloat = 5
        static let commonBorderWidth:CGFloat = 2
        static let ThemeHeaderTitleSize:CGFloat = 30
        static let ThemeSectionHeaderTitleSize:CGFloat = 20
        
        static let themeDetailsTitilesize:CGFloat = 12
        static let themeDetailsValuesize:CGFloat = 18
    }
}
