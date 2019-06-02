//
//  GiphyCollectionViewCelll.swift
//  GiphyExplorer
//
//  Created by Arjav Lad on 30/05/19.
//  Copyright © 2019 Arjav Lad. All rights reserved.
//

import UIKit
import SDWebImageFLPlugin

class GiphyCollectionViewCelll: UICollectionViewCell {
    
    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with giphy: Giphy?) {
        if let giphy = giphy {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
            imageView.sd_setImage(with: giphy.url)
        } else {
            imageView.image = #imageLiteral(resourceName: "placeHolderImage")
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        }
    }

}
