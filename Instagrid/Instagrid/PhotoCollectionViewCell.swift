//
//  PhotoCollectionViewCell.swift
//  Instagrid
//
//  Created by Claire on 29/06/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

enum PhotoType {
    case placeholder
    case photo(UIImage)
}

//This subclass represents an image inside the photo grid displayed to the user
//Based on the given PhotoType value, it displays either an image selected from the photo library or a placerholder image if no selection has yet been done
class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    
    var photoType: PhotoType = .placeholder {
        didSet {
            switch photoType {
            case .placeholder:
                photoImageView.contentMode = .center
                photoImageView.image = UIImage(named: "Cross")

            case .photo(let image):
                photoImageView.contentMode = .scaleAspectFill
                photoImageView.image = image
            }
        }
    }
}
