//
//  secureContext.swift
//  movieApp
//
//  Created by Amit Mathur on 9/7/18.
//  Copyright © 2018 Amit Mathur. All rights reserved.
//

import Foundation

final class secureContext: NSObject {
    static let shared = secureContext()
    var userSearchArray: [String] = []
    let dateFormatter = DateFormatter()
    var totalMoviePage: Int = 1
    
    public func saveSearchData(str: String) {
        if self.userSearchArray.count == 10 && !self.userSearchArray.contains(str) {
            self.userSearchArray.removeFirst()
        } else if !self.userSearchArray.contains(str) {
            self.userSearchArray.append(str)
        }
        UserDefaults.standard.set(self.userSearchArray, forKey: "searchData")
        UserDefaults.standard.synchronize()
    }
    
    public func getSearchData(str: String) -> [String] {
        if let arr = UserDefaults.standard.array(forKey: "searchData") as? [String] {
            return arr
        }
        return []
    }
    
   func strToDate(releaseStr: String) -> NSDate {
        dateFormatter.dateFormat = "yyyy-mm-dd"
        dateFormatter.timeZone = TimeZone.current
        guard let date = dateFormatter.date(from:releaseStr) else {
            print("ERROR: Date conversion failed due to mismatched format.")
            return NSDate()
        }
        return date as NSDate
    }
}
