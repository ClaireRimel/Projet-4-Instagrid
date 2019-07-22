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

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    
    var photoType: PhotoType = .placeholder {
        didSet {
            switch photoType {
            case .placeholder:
                photoImageView.contentMode = .scaleAspectFit
                photoImageView.image = UIImage(named: "Cross")

            case .photo(let image):
                photoImageView.contentMode = .scaleAspectFill
                photoImageView.image = image
            }
        }
    }
}
