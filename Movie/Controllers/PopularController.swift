//
//  PopularController.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 06/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import UIKit
import SwiftSoup

class PopularController: BaseVC {
    
    var postCards = [PostCard]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HTMLConverter.shared.urlToHTMLString(url: "\(APIService.shared.BASE_URL)/movie") { (htmlString, error) in
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
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - SearchBar Delegate Medthods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
