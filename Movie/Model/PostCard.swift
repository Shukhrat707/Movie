//
//  PostCard.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 08/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import SwiftSoup

struct PostCard: Equatable {
    
    var movieTitle:        String = ""
    var moviePubDate:      String = ""
    var movieDescription:  String = ""
    var movieRate:         Double = 0.0
    var movieThumbnailUrl: String = ""
    var movieId:           String = ""
    
    init(withElement element: Element) {
        
        let divElements = try! element.select("div")
        var movieDescInfo: String = ""
        var image_url:     String = ""
        var movieId:       String = ""
        var movieTitle:    String = ""
        var movieRank:     String = ""
        var pubDate:       String = ""
        
        for element in divElements {

            if try! element.className() == "image_content" {
                
                // Get movie thumbnail url
                let imageElement = try! element.select("img")
                image_url = try! imageElement.attr("data-src")
            }
            
            if try! element.className() == "outer_ring" {
                
                // Get movie rate with double
                let rankElement = try! element.select("div")
                movieRank = try! rankElement.attr("data-percent")
            }
            
            if try! element.className() == "info" {
                
                // Get Movie ID and Title name
                let movieInfo = try! element.select("a")
                movieId    = try! movieInfo.attr("href")
                movieTitle = try! movieInfo.attr("title")
                
                // Get Movie Description
                movieDescInfo = try! element.select("p").array()[0].text()
            }
            
            if try! element.className() == "flex" {
                pubDate = try! element.select("span").text()
            }
        }
        self.moviePubDate      = pubDate
        self.movieThumbnailUrl = image_url
        self.movieDescription  = movieDescInfo
        self.movieId           = movieId
        self.movieTitle        = movieTitle
        self.movieRate         = Double(movieRank)!
    }
}
