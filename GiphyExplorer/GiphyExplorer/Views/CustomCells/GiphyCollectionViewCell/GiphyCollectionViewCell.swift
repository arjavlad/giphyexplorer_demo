//
//  GiphyCollectionViewCell.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import UIKit
import SDWebImageFLPlugin

final class GiphyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    /// Configures the cell with Giphy, if nil is passed then sets the placeholder image
    ///
    /// - Parameter giphy: Giphy
    func configure(with giphy: Giphy?) {
        guard let giphy = giphy else {
            imageView.image = #imageLiteral(resourceName: "placeHolderImage")
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            return
        }
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        imageView.sd_setImage(with: giphy.url, placeholderImage: #imageLiteral(resourceName: "placeHolderImage"), options: .continueInBackground, context: nil)
    }
}
