//
//  LayoutCollectionViewCell.swift
//  Instagrid
//
//  Created by Claire on 30/06/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

// Represents one LayoutType case, displaying the corresponding image for each. It also displays an image on top for its selected state.
class LayoutCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var layoutImageView: UIImageView!
    @IBOutlet var selectedImageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            selectedImageView.isHidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // We'll initially set the check image to be hidden
        selectedImageView.isHidden = true
    }
}
