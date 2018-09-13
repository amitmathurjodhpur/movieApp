//
//  Date+Utility.swift
//  movieApp
//
//  Created by Amit Mathur on 9/8/18.
//  Copyright © 2018 Amit Mathur. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM dd,yyyy"
        return dateFormatter.string(from: self as Date)
    }
}

public extension UIViewController {
   public func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
