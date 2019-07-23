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
    @IBOutlet var footerView: FooterView!
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var photoGridView: UIView!
    @IBOutlet var photoGridCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var photoGridCenterXConstraint: NSLayoutConstraint!
    
    let photoLibraryService = PhotoLibraryService()
    let photoShareService = PhotoShareService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoLibraryService.delegate = self
        photoShareService.delegate = self
        footerView.delegate = self
        
        // We initially set the number the touches required by the swipe gesture and also its direction based on the current device orientation.
        swipeGesture.numberOfTouchesRequired = 1
        updateSwipeOrientation()
        
        // We subscribe this class to the Notification Center, triggering a call to the function "updateSwipeOrientation" when the device orientation changes, event which we use to set the correct swipeGesture direction.
        NotificationCenter.default.addObserver(self, selector: #selector(updateSwipeOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func updateSwipeOrientation() {
        switch UIDevice.current.orientation {
        case .portrait:
            swipeGesture.direction = .up
        case .landscapeLeft, .landscapeRight:
            swipeGesture.direction = .left
        default:
            break
        }
    }
    
    @IBAction func swipeToShare(_ sender: UISwipeGestureRecognizer) {
     photoShareService.start(viewController: self)
    }
    
    func shareAnimation(begin: Bool) {
        switch UIDevice.current.orientation {
        case .portrait:
            photoGridCenterYConstraint.constant = begin ? -1000 : 0
        case .landscapeLeft, .landscapeRight:
            photoGridCenterXConstraint.constant = begin ? -1000 : 0
        default:
            break
        }
        
        UIView.animate(withDuration: 0.6) {
            self.view.layoutIfNeeded()
        }
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
        cell.photoType = .placeholder
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoLibraryService.photoAccess(indexPath: indexPath,
                                        viewController: self)
    }
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoCollectionView.collectionViewLayout.invalidateLayout()
    }
}


extension ViewController: FooterViewDelegate {
    
    func didSelect(layoutType: LayoutType) {
        self.layoutType = layoutType
    }
}

extension ViewController: PhotoLibraryServiceDelegate {
    
    func didChoose(image: UIImage, indexPath: IndexPath) {
        let cell = photoCollectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        cell.photoType = .photo(image)
    }
}

extension ViewController: PhotoShareServiceDelegate {
    
    func willTakeImage() -> UIView {
       return photoGridView
    }
    
    func willDisplayShareSheet() {
         shareAnimation(begin: true)
    }
    
    func didDisplayShareSheet() {
        shareAnimation(begin: false)
    }
}
