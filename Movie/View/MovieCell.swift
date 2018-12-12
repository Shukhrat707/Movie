//
//  MovieCell.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 06/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import UIKit
import SDWebImage
import MKRingProgressView

class MovieCell: UITableViewCell {
    
    @IBOutlet var movieImageView:    UIImageView!
    @IBOutlet var movieTitle:        UILabel!
    @IBOutlet var moviePublishedDay: UILabel!
    @IBOutlet var movieDescription:  UILabel!
    @IBOutlet var movieRank:         UILabel!
    @IBOutlet var progressView:      RingProgressView!
    
    var movieID: String = ""
    
    var postCard: PostCard? = nil {
        didSet {
            setupMovieCell()
        }
    }
    
    fileprivate func setupMovieCell() {
        
        guard let postCard = postCard else { return }
        guard let imageUrl = URL(string: "\(postCard.movieThumbnailUrl)") else { return }
        movieTitle.text        = postCard.movieTitle
        movieDescription.text  = postCard.movieDescription
        moviePublishedDay.text = postCard.moviePubDate
        movieID                = postCard.movieId
        movieImageView.sd_setImage(with: imageUrl, completed: nil)
        
        movieRank.text         = "\(Int(postCard.movieRate))%"
        
        if Int(postCard.movieRate) == 0 {
            movieRank.text = "NR"
            progressView.startColor = NO_COLOR
            progressView.endColor   = NO_COLOR
            
        } else if Int(postCard.movieRate) < 40 {
            progressView.startColor = QUARTER_COLOR
            progressView.endColor   = QUARTER_COLOR
            progressView.backgroundRingColor = QUARTER_COLOR.withAlphaComponent(0.3)
        } else if Int(postCard.movieRate) < 70 {
            progressView.startColor = HALF_COLOR
            progressView.endColor   = HALF_COLOR
            progressView.backgroundRingColor = HALF_COLOR.withAlphaComponent(0.3)
            
        } else {
            progressView.startColor = FULL_COLOR
            progressView.endColor   = FULL_COLOR
            progressView.backgroundRingColor = FULL_COLOR.withAlphaComponent(0.3)
        }

        progressView.animateTo(Int(postCard.movieRate))
    }
}
