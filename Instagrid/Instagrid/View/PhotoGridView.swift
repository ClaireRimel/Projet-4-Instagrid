//
//  PhotoGridView.swift
//  Instagrid
//
//  Created by Claire on 28/07/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

protocol PhotoGridViewDelegate: class {
    
    func photoGridViewDidSelect(_ photoGridView: PhotoGridView, indexPath: IndexPath)
}

class PhotoGridView: UIView {
    
    let borderWidth: CGFloat = 15
    weak var delegate: PhotoGridViewDelegate?
    
    @IBOutlet var photoCollectionView: UICollectionView!
    
    var layoutType: LayoutType = .oneTopTwoBottom {
        didSet {
            photoCollectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }
    
    func set(image: UIImage, indexPath: IndexPath) {
        let cell = photoCollectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        cell.photoType = .photo(image)
    }
}

extension PhotoGridView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutType.numberOfItems(for: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return layoutType.sections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.photoType = .placeholder
        return cell
    }
}

extension PhotoGridView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.photoGridViewDidSelect(self, indexPath: indexPath)
    }
}


extension PhotoGridView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightMargin = (layoutType.sections + 1) * Int(borderWidth)
        let divisableHeight = Double(collectionView.frame.height) - Double(heightMargin)
        let cellHeight = divisableHeight / Double(layoutType.sections)
        
        let numberOfItems = layoutType.numberOfItems(for: indexPath.section)
        let widthMargin = (numberOfItems + 1) * Int(borderWidth)
        let divisableWidth = Double(collectionView.frame.width) - Double(widthMargin)
        let cellWidth = divisableWidth / Double(numberOfItems)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let top: CGFloat = section == 0 ? borderWidth : borderWidth/2
        let bottom: CGFloat = section == layoutType.sections - 1 ? borderWidth : borderWidth/2
        
        return UIEdgeInsets(top: top, left: borderWidth, bottom: bottom, right: borderWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return borderWidth
    }
}
