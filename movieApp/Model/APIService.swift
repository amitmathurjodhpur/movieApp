//
//  APIService.swift
//  movieApp
//
//  Created by Amit Mathur on 9/4/18.
//  Copyright © 2018 Amit Mathur. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject {
    
   lazy var endPoint: String = {
        return "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838"
    }()
    
    func searchMovieData(page: Int, searchParam: String, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        let urlString = "\(endPoint)&query=\(searchParam)&page=\(String(page))"
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json["results"] as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                    }
                    if let totalPage = json["total_pages"] as? Int {
                        secureContext.shared.totalMoviePage = totalPage
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}
