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
        
      //  photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    @IBAction func didSelectLayoutA(_ sender: Any) {
        layoutType = .oneTopTwoBottom
    }
    
    @IBAction func didSelectLayoutB(_ sender: Any) {
        layoutType = .twoTopOneBottom
    }
    
    @IBAction func didSelectLayoutC(_ sender: Any) {
        layoutType = .twoTopTwoBottom
    }
    
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




