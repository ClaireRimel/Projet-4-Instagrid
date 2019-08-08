//
//  FooterView.swift
//  Instagrid
//
//  Created by Claire on 30/06/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

protocol FooterViewDelegate: class {
    
    func footerViewDidSelect(_ footerView: FooterView, indexPath: IndexPath)
}

class FooterView: UIView {

    @IBOutlet var layoutCollectionView: UICollectionView!
  
    //We put is this constent, all cases of LayoutType available
    let array = LayoutType.allCases
    
    weak var delegate: FooterViewDelegate?
    
    //Gets executed when the view gets loaded on memory, allowing us to do an initial setup on the collection view.
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutCollectionView.dataSource = self
        layoutCollectionView.delegate = self
        
        // We programmatically force for the first layout to be selected
        layoutCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
    }

    //It changes the scroll direction of the collection view based on the device's current orientation
    func didChangeDeviceOrientation() {
        guard let layout = layoutCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        switch UIDevice.current.orientation {
        case .portrait:
            layout.scrollDirection = .horizontal
        case .landscapeLeft, .landscapeRight:
            layout.scrollDirection = .vertical
        default:
            break
        }
    }
}

//By making the class to conform to the UICollectionViewDataSource protocol, we provide the require data to display all the available layout cases.
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

//By making the class conform to the UICollectionViewDelegate protocol, we allow the class to give the indexPath of the layout selected by the user to its delegate.
extension FooterView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.footerViewDidSelect(self, indexPath: indexPath)
    }
}

//By making the class conform to the UICollectionViewDelegateFlowLayout, we define the cell's size.
extension FooterView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

