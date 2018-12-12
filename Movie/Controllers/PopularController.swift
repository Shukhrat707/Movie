//
//  PopularController.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 06/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire

class PopularController: BaseVC, UISearchBarDelegate {
    
    var timer: Timer?
    var postCards = [PostCard]()
    var postCard: PostCard!
    let searchController = UISearchController(searchResultsController: nil)
    var postCardSearchView = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?.first as? UIView

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        
        if postCards.count < 1 {
            searchQueryFor(postCard: "/movie")
        }
        
        searchBarSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDismissNotification), name: DISMISS_PREVIEW_VIEW, object: nil)
    }
    
    @objc fileprivate func handleDismissNotification() {
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    fileprivate func searchQueryFor(postCard postcard: String) {
      
        HTMLConverter.shared.urlToHTMLString(url: "\(HTMLConverter.shared.BASE_URL)\(postcard)") { (htmlString, error) in
            if let error = error {
                print("Error: \(error)")
            }
            
            if let htmlString = htmlString {
                self.parseHTML(html: htmlString)
            }
        }
    }
    
    func parseHTML(html: String) {
        let elements: Elements = try! SwiftSoup.parse(html).select("div")
        postCards.removeAll()
        
        for element: Element in elements.array() {
            if try! element.className() == "item poster card" {
                let postCard = PostCard(withElement: element)
                postCards.append(postCard)
                print("PostCard: \(postCard)")
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - SearchBar Delegate Medthods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var query = "/search?query=\(searchBar.text!)"
        
        if searchBar.text == nil || searchBar.text == "" {
            query = "/movie"
        }
        
        postCards = []
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.searchQueryFor(postCard: query)
            self.tableView.reloadData()
        })
    }
    
    //MARK: - SearchBar Setup
    fileprivate func searchBarSetup() {
        
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        
    }
    
    //MARK: - TableView Setup
    fileprivate func tableViewSetup() {
        
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        postCard = postCards[indexPath.row]
        performSegue(withIdentifier: "GoToPreview", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return postCardSearchView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return postCards.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MovieCell
        cell.postCard = postCards[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postCards.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToPreview" {
            let vc = segue.destination as! PreviewController
            vc.postCard = postCard
        }
    }
}
