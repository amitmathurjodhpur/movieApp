//
//  MovieSearchController.swift
//  movieApp
//
//  Created by Amit Mathur on 9/8/18.
//  Copyright © 2018 Amit Mathur. All rights reserved.
//

import Foundation
import UIKit

extension MovieListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let theText = searchBar.text, !theText.isEmpty else {
            return
        }
        searchActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let inputString = searchText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        guard let theText = searchBar.text, !inputString.isEmpty else {
            if inputString == "" {
                searchBar.resignFirstResponder()
                searchActive = false
                self.autoCompleteTableView.isHidden = true
                filteredUserSearchArray.removeAll()
                self.tableView.reloadData()
            }
            return
        }
        searchActive = true
        
        filteredUserSearchArray = secureContext.shared.userSearchArray.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: theText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if filteredUserSearchArray.count > 0 {
            self.autoCompleteTableView.isHidden = false
            self.autoCompleteTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false
        self.autoCompleteTableView.isHidden = true
        filteredUserSearchArray.removeAll()
        guard let theText = searchBar.text, !theText.isEmpty else {
            return
        }
        self.updateTableContent(searchText: theText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.autoCompleteTableView.isHidden = true
        if self.movieObjects.count > 0 {
            CoreDataStack.sharedInstance.clearData()
            self.movieObjects.removeAll()
        }
        self.tableView.reloadData()
    }
    
    func configureSearch() {
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Movie"
        tableView.tableHeaderView = searchController.searchBar
        tableView.keyboardDismissMode = .onDrag
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
}

