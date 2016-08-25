//
//  CollectionCell.swift
//  VirtualTourist
//
//  Created by Hasic Dalmir on 24/07/16.
//  Copyright © 2016 abc. All rights reserved.
//

import Foundation
import UIKit

class CollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    var photo: Photo? = nil {
        didSet {
            imageView.image = nil
            activityIndicator.startAnimating()
            activityIndicator.hidden = false
            
            photo?.loadImage({ (image, error) -> Void in
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            })
        }
    }
    
    
    
}