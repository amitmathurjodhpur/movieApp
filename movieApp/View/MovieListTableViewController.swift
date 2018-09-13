//
//  MovieListTableViewController.swift
//  movieApp
//
//  Created by Amit Mathur on 9/4/18.
//  Copyright © 2018 Amit Mathur. All rights reserved.
//

import UIKit
import CoreData


class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var autoCompleteTableView: UITableView!
    private let cellID = "cellIdentifier"
    private let autoCompletecellID = "searchcellIdentifier"
    var movieObjects: [Movie] = []
    var filteredUserSearchArray: [String] = []
    var searchActive: Bool = false
    
    var currentPage = 1
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Movie.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearch()
    }
    
    func configureTableView() {
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        autoCompleteTableView.isHidden = true
        autoCompleteTableView.layer.borderColor = UIColor.brown.cgColor
        autoCompleteTableView.layer.borderWidth = 1.5
        tableView.accessibilityIdentifier = "myUniqueTableViewIdentifier"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Movies"
        if let arr = UserDefaults.standard.array(forKey: "searchData") as? [String] {
           secureContext.shared.userSearchArray = arr
        }
        CoreDataStack.sharedInstance.clearData()
        self.movieObjects.removeAll()
    }
   
    func updateTableContent(searchText: String) {
           do {
                try self.fetchedhResultController.performFetch()
            } catch let error  {
                print("ERROR: \(error)")
            }
        
            let service = APIService()
            service.searchMovieData(page: currentPage, searchParam: searchText) { [weak self] (result) in
                switch result {
                case .Success(let data):
                    if (self?.saveInCoreDataWith(array: data)) != nil {
                        if let arr = self?.fetchedhResultController.fetchedObjects as? [Movie] {
                            secureContext.shared.saveSearchData(str: searchText)
                            self?.movieObjects = arr
                        }
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                case .Error(let message):
                    DispatchQueue.main.async {
                        self?.showAlertWith(title: "Error", message: message)
                    }
                }
             }
        }
    
    //Mark Delegate and Data Source
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if tableView == autoCompleteTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: autoCompletecellID) {
                cell.textLabel?.text = filteredUserSearchArray[indexPath.row]
                cell.textLabel?.textAlignment = .center
                 cell.accessibilityIdentifier = "myCell_\(indexPath.row)"
                return cell
            }
        } else {
          if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? dataCellTableViewCell {
             cell.accessibilityIdentifier = "myCell_\(indexPath.row)"
            let dataCell = movieObjects[indexPath.row]
            cell.movieName.text = dataCell.title
            cell.movieRealeaseDate.text = dataCell.release_date?.toString()
            cell.movieOverview.text = dataCell.overview
            if let imagePath = dataCell.poster_path {
            cell.moviePoster.loadImageUsingCacheWithURLString("http://image.tmdb.org/t/p/w92\(imagePath)", placeHolder: UIImage (named: "NO_IMAGE"))
            }
            if indexPath.row == movieObjects.count - 1 { // last cell
                if secureContext.shared.totalMoviePage > currentPage { // more items to fetch
                    if let theText = searchController.searchBar.text, !theText.isEmpty  {
                        currentPage += 1
                        self.updateTableContent(searchText: theText)
                    }
                }
            }
             return cell
       }
        }
       return  UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {
            return filteredUserSearchArray.count
        }
       return movieObjects.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == autoCompleteTableView {
            searchController.searchBar.resignFirstResponder()
            self.updateTableContent(searchText: filteredUserSearchArray[indexPath.row])
            filteredUserSearchArray.removeAll()
            searchActive = false
            self.autoCompleteTableView.isHidden = true
        }
    }
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

extension MovieListViewController {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
    
    private func createMovieEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let movieEntity = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context) as? Movie {
            if let val = dictionary["id"] as? Int, let idStr = String(val) as String? {
                movieEntity.id = idStr
            }
            movieEntity.title = dictionary["title"] as? String
            movieEntity.overview = dictionary["overview"] as? String
            if let dateStr = dictionary["release_date"] as? String {
                movieEntity.release_date = secureContext.shared.strToDate(releaseStr: dateStr)
            }
            movieEntity.poster_path = dictionary["poster_path"] as? String
            return movieEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) -> Bool {
        let _ = array.map{self.createMovieEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            return true
        } catch let error {
            print(error)
            return false
        }
        
    }    

}



