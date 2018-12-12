//
//  TopController.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 06/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import UIKit
import SwiftSoup

class TopController: BaseVC {
    
    var topPostCards = [PostCard]()
    var postCard: PostCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchQuery()
        
        let refreshControl = UIRefreshControl()
        let refreshTitle = "Pull to refresh..."
        refreshControl.attributedTitle = NSAttributedString(string: refreshTitle)
        refreshControl.addTarget(self,
                                 action: #selector(refreshOptions(sender:)),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    fileprivate func searchQuery() {
        HTMLConverter.shared.urlToHTMLString(url: "\(HTMLConverter.shared.BASE_URL)/movie/top-rated") { (htmlString, error) in
            if let error = error {
                print("Error: \(error)")
            }
            
            if let htmlString = htmlString {
                self.parseHTML(html: htmlString)
            }
        }
    }
    
    @objc fileprivate func refreshOptions(sender: UIRefreshControl) {
        
        searchQuery()
        sender.endRefreshing()
    }
    
    func parseHTML(html: String) {
        let elements: Elements = try! SwiftSoup.parse(html).select("div")
        topPostCards.removeAll()
        
        for element: Element in elements.array() {
            if try! element.className() == "item poster card" {
                let postCard = PostCard(withElement: element)
                topPostCards.append(postCard)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MovieCell
        cell.postCard = topPostCards[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return topPostCards.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        postCard = topPostCards[indexPath.row]
        performSegue(withIdentifier: "GoToPreview", sender: self)
    }
    
    // Prepare segue to send selected item to PreviewViewController using segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToPreview" {
            let destinationVC = segue.destination as! PreviewController
            destinationVC.postCard = self.postCard
        }
    }
}
