//
//  PreviewController.swift
//  Movie
//
//  Created by Bekzod Rakhmatov on 09/12/2018.
//  Copyright © 2018 Bekzod Rakhmatov. All rights reserved.
//

import UIKit
import MKRingProgressView
import SDWebImage
import SwiftSoup
import AVKit
import YouTubePlayer

let DISMISS_PREVIEW_VIEW = Notification.Name("DISMISS_PREVIEW_VIEW")

class PreviewController: UIViewController, YouTubePlayerDelegate {

    @IBOutlet var backgroundImage:     UIImageView!
    @IBOutlet var movieImage:          UIImageView!
    @IBOutlet var movieTitle:          UILabel!
    @IBOutlet var movieDescription:    UILabel!
    @IBOutlet var progressLabel:       UILabel!
    @IBOutlet var playButton:          UIButton!
    @IBOutlet var progressView:        RingProgressView!
    @IBOutlet var youtubePreview:      YouTubePlayerView!
    @IBOutlet var popupBackgroundView: UIView!
    @IBOutlet var scrollView:          UIScrollView!
    
    var postCard: PostCard!
    var videoUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupItems()
        setupGesture()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate func setupGesture() {
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        popupBackgroundView.addGestureRecognizer(singleTap)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss))
        backgroundImage.addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handleDismiss(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .changed {
            let translation = gesture.translation(in: view)
            view.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = .identity
                
                if translation.y > 50 {
                    
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: DISMISS_PREVIEW_VIEW, object: nil)
                }
            })
        }
    }
    
    @objc fileprivate func handleSingleTap() {
        
        youtubePreview.pause()
        
        UIView.transition(with: view, duration: 3.0, options: .curveEaseInOut, animations: {
            self.popupBackgroundView.isHidden = true
        })
    }
  
    func parseHTML(html: String) {
        
        let divElements: Elements = try! SwiftSoup.parse(html).select("div")
        for element: Element in divElements.array() {
            if try! element.className() == "overview" {
                // Get Movie Description
                DispatchQueue.main.async {
                    self.movieDescription.text = try! element.select("p").text()
                }
            }
            
            if try! element.className() == "backdrop" {
                let backgroundImageElement = try! element.select("img")
                let bgUrl = try! backgroundImageElement.attr("data-src")
                guard let imageUrl = URL(string: bgUrl) else { return }
                DispatchQueue.main.async {
                    self.backgroundImage.sd_setImage(with: imageUrl, completed: nil)
                }
            }
            
            if try! element.className() == "video" {
                let videoUrlElement = try! element.select("iframe")
                let videoUrlIn = try! videoUrlElement.attr("data-src")
                DispatchQueue.main.async {
                    self.videoUrl = videoUrlIn
                    self.playButton.isEnabled = true
                }
            }
        }
    }
    
    fileprivate func setupItems() {
        
        HTMLConverter.shared.urlToHTMLString(url: "\(HTMLConverter.shared.BASE_URL)\(postCard.movieId)") { (htmlString, error) in
            if let error = error {
                print("Error: \(error)")
            }
            
            if let htmlString = htmlString {
                self.parseHTML(html: htmlString)
            }
        }
        
        guard let imageUrl = URL(string: "\(postCard.movieThumbnailUrl)") else { return }
    
        movieTitle.text = postCard.movieTitle
        movieImage.sd_setImage(with: imageUrl, completed: nil)
        progressLabel.text = "\(Int(postCard.movieRate))%"
        if Int(postCard.movieRate) == 0 {
            progressLabel.text = "NR"
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.progressView.animateTo(Int(self.postCard.movieRate))
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
    
        let urlString = videoUrl.replacingOccurrences(of: "//www.youtube.com/embed/", with: "")
        let videoId = urlString.components(separatedBy: "?").first
        youtubePreview.playerVars = ["playsinline": "1" as AnyObject]
        youtubePreview.loadVideoID(videoId!)
        
        youtubePreview.delegate = self

        UIView.transition(with: view, duration: 3.0, options: .curveEaseInOut, animations: {
            self.popupBackgroundView.isHidden = false
        })

    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: DISMISS_PREVIEW_VIEW, object: nil)
    }
}
