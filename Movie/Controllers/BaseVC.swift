//
//  BaseVC.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 08/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import UIKit

class BaseVC: UITableViewController {
    
    let cellId = "cellId"
    var isStatusBarHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDismissNotification), name: DISMISS_PREVIEW_VIEW, object: nil)
    }
    
    @objc fileprivate func handleDismissNotification() {
        
        isStatusBarHidden = false
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    //MARK: - TableView Setup
    fileprivate func tableViewSetup() {
        
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
