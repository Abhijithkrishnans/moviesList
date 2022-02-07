//
//  MLUtilities.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 02/02/22.
//

import Foundation
import UIKit
//MARK: Data Parser Helpers
struct MLUtilities {
    func getDecodedBundleData<T:Codable>(WithName name:String, ext:String, type:T.Type) -> T? {
        let loadedDataModel:T?
        guard let data = getDataFromBundle(WithName: name, ext: ext)  else {
            return nil
        }
        let decoder = JSONDecoder()
        loadedDataModel = try? decoder.decode(type.self, from: data)
        return loadedDataModel
    }
    func getDataFromBundle(WithName name:String, ext:String) -> Data? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: ext) else {
            return nil
        }
        guard let data = try? Data(contentsOf: bundleURL)  else {
            return nil
        }
        return data
    }
    func getDecodedData<T:Codable>(type:T.Type, data:Data) -> T? {
        let decoder = JSONDecoder()
        let loadedDataModel:T?
        loadedDataModel = try? decoder.decode(type.self, from: data)
        return loadedDataModel
    }
}

// MARK: Date Formater Helpers
extension MLUtilities {
    func getDateFromString(datestring:String,dateformat:String)-> Date {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = dateformat//"yyyy-MM-dd hh:mm a"
        let date = dayTimePeriodFormatter.date(from: datestring)
        return date!
    }
    func getStringFromDate(datestring:NSDate,dateformat:String)-> String    {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = dateformat//"EE,d MMM yy h:mm a"
        let timestring = timeFormatter.string(from: datestring as Date)
        return timestring
    }
}
