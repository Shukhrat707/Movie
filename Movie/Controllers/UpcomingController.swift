//
//  UpcomingController.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 06/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import UIKit
import SwiftSoup

class UpcomingController: BaseVC {

    var upcomingPostCards = [PostCard]()
    var postCard: PostCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchMovie()
        let refreshControl = UIRefreshControl()
        let refreshTitle = "Pull to refresh..."
        refreshControl.attributedTitle = NSAttributedString(string: refreshTitle)
        refreshControl.addTarget(self,
                                 action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc fileprivate func refreshOptions(sender: UIRefreshControl) {
        
        searchMovie()
        sender.endRefreshing()
    }
    
    
    fileprivate func searchMovie() {
        HTMLConverter.shared.urlToHTMLString(url: "\(HTMLConverter.shared.BASE_URL)/movie/upcoming") { (htmlString, error) in
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
        upcomingPostCards.removeAll()
        
        for element: Element in elements.array() {
            if try! element.className() == "item poster card" {
                let postCard = PostCard(withElement: element)
                upcomingPostCards.append(postCard)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MovieCell
        cell.postCard = upcomingPostCards[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return upcomingPostCards.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        postCard = upcomingPostCards[indexPath.row]
        performSegue(withIdentifier: "GoToPreview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToPreview" {
            let destinationVC = segue.destination as! PreviewController
            destinationVC.postCard = self.postCard
        }
    }
}
