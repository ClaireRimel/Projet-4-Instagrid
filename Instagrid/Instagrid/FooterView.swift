//
//  FooterView.swift
//  Instagrid
//
//  Created by Claire on 30/06/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

class FooterView: UIView {

    @IBOutlet var layoutCollectionView: UICollectionView!
  
    let array = LayoutType.allCases
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutCollectionView.dataSource = self
        layoutCollectionView.delegate = self
    }
}

extension FooterView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayoutCollectionViewCell", for: indexPath) as! LayoutCollectionViewCell
        cell.layoutImageView.image = array[indexPath.row].image
        return cell
    }
}

extension FooterView: UICollectionViewDelegate {
    
    
}

