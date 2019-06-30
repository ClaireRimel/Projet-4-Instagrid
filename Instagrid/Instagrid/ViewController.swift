//
//  ViewController.swift
//  Instagrid
//
//  Created by Claire on 07/05/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var layoutType: LayoutType = .oneTopTwoBottom {
       didSet {
            photoCollectionView.reloadData()
        }
    }

    @IBOutlet var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
    }
    
//    @IBAction func didSelectLayoutA(_ sender: Any) {
//        layoutType = .oneTopTwoBottom
//    }
//    
//    @IBAction func didSelectLayoutB(_ sender: Any) {
//        layoutType = .twoTopOneBottom
//    }
//    
//    @IBAction func didSelectLayoutC(_ sender: Any) {
//        layoutType = .twoTopTwoBottom
//    }
//    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutType.numberOfItems(for: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return layoutType.sections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.image = UIImage(named: "Cross")
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {

  
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightMargin = (layoutType.sections + 1) * 10
        let divisableHeight = Double(collectionView.frame.height) - Double(heightMargin)
        let cellHeight = divisableHeight / Double(layoutType.sections)
        
        let numberOfItems = layoutType.numberOfItems(for: indexPath.section)
        let widthMargin = (numberOfItems + 1) * 10
        let divisableWidth = Double(collectionView.frame.width) - Double(widthMargin)
        let cellWidth = divisableWidth / Double(numberOfItems)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let top: CGFloat = section == 0 ? 10 : 5
        let bottom: CGFloat = section == layoutType.sections - 1 ? 10 : 5
//        let left: CGFloat =
        
        return UIEdgeInsets(top: top, left: 10, bottom: bottom, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}
