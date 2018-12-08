//
//  HTMLConverter.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 08/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import Foundation
import UIKit

class HTMLConverter {
    
    static let shared = HTMLConverter()
    
    func urlToHTMLString(url: String, completetionHandler: @escaping(_ html: String?, _ error: String?) -> ()) {
        guard let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let webUrl = URL(string: url) else {
            completetionHandler(nil, "Invalid URL")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [] in
            do {
                let myHTMLString = try String(contentsOf: webUrl, encoding: .utf8)
                completetionHandler(myHTMLString, nil)
            } catch let error {
                print("Error: \(error)")
                completetionHandler(nil, error.localizedDescription)
            }
        }
    }
}
