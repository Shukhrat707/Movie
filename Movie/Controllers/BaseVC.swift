//
//  BaseVC.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 08/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import UIKit

class BaseVC: UITableViewController, UISearchBarDelegate {
    
    let cellId = "cellId"
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        searchBarSetup()
    }
    
    //MARK: - TableView Setup
    fileprivate func tableViewSetup() {
        
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    //MARK: - SearchBar Setup
    fileprivate func searchBarSetup() {
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
    }
}
