//
//  ViewController.swift
//  Instagrid
//
//  Created by Claire on 07/05/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate: class {
    
    func viewControllerDidSelect(_ viewController: ViewController, indexPath: IndexPath)
}

class ViewController: UIViewController {
    
    
    @IBOutlet var footerView: FooterView!
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var photoGridView: PhotoGridView!
    @IBOutlet var photoGridCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var photoGridCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var swipeToShareStackView: UIStackView!

    var isShareAnimationActive: Bool = false

    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        footerView.delegate = self
        photoGridView.delegate = self

        // We initially set the number the touches required by the swipe gesture and also its direction based on the current device orientation.
        swipeGesture.numberOfTouchesRequired = 1
        didChangeDeviceOrientation()
        
        // We subscribe this class to the Notification Center, triggering a call to the function "updateSwipeOrientation" when the device orientation changes, event which we use to set the correct swipeGesture direction.
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        
       
    }
    
    @objc func didChangeDeviceOrientation() {
        switch UIDevice.current.orientation {
        case .portrait:
            swipeGesture.direction = .up
        case .landscapeLeft, .landscapeRight:
            swipeGesture.direction = .left
        default:
            break
        }
        
        footerView.didChangeDeviceOrientation()
        
        if isShareAnimationActive {
            switch UIDevice.current.orientation {
            case .portrait:
                photoGridCenterYConstraint.constant = -1000
                photoGridCenterXConstraint.constant = 0
                view.layoutIfNeeded()

            case .landscapeLeft, .landscapeRight:
                photoGridCenterYConstraint.constant = 0
                photoGridCenterXConstraint.constant = -1000
                view.layoutIfNeeded()

            default:
                break
            }
        }
    }
    
    @IBAction func swipeToShare(_ sender: UISwipeGestureRecognizer) {
     photoShareService.start(viewController: self)
    }
    
    
    func shareAnimation(begin: Bool) {
        isShareAnimationActive = begin
        
        switch UIDevice.current.orientation {
        case .portrait:
            photoGridCenterYConstraint.constant = begin ? -1000 : 0
        case .landscapeLeft, .landscapeRight:
            photoGridCenterXConstraint.constant = begin ? -1000 : 0
        default:
            break
        }
        
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
            self.photoGridView.alpha = begin ? 0.0 : 1.0
            self.swipeToShareStackView.alpha = begin ? 0.0 : 1.0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        photoCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func set(image: UIImage, indexPath: IndexPath) {
        photoGridView.set(image: image, indexPath: indexPath)
    }
    
    func set(layoutType: LayoutType) {
        photoGridView.layoutType = layoutType
    }
}

extension ViewController: FooterViewDelegate {
    
    func footerViewDidSelect(_ footerView: FooterView, indexPath: IndexPath) {
        delegate?.viewControllerDidSelect(self, indexPath: indexPath)
    }
}

extension ViewController: PhotoGridViewDelegate {
    
    func photoGridViewDidSelect(_ photoGridView: PhotoGridView, indexPath: IndexPath) {
        PhotoLibraryService.photoAccess(indexPath: indexPath,
                                        viewController: self)
    }
}
