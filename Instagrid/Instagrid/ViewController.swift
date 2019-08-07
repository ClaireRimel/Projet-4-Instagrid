//
//  ViewController.swift
//  Instagrid
//
//  Created by Claire on 07/05/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate: class {
    
    func viewController(_ viewController: ViewController, didSelectLayoutAt indexPath: IndexPath)
    
    func viewController(_ viewController: ViewController, didSelectPhotoAt indexPath: IndexPath)
    
    func viewControllerDidSwipeToShare(_ viewController: ViewController)

    func viewControllerDidPressOpenSettings(_ viewController: ViewController)
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
    
    var isAnimating: Bool = false
    
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
        
        if isAnimating {
            photoGridView.isHidden = true
            swipeToShareStackView.isHidden = true
            photoGridView.layer.removeAllAnimations()
            swipeToShareStackView.layer.removeAllAnimations()
        }
        
        
        // Check if the Share Animation is Active, if true, change the position of the photoGrid to go outside of the screen
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
        // Use to force to reappear in the center of the screen
        } else {
            photoGridCenterXConstraint.constant = 0
            photoGridCenterYConstraint.constant = 0
            view.layoutIfNeeded()
            
            photoGridView.isHidden = false
            swipeToShareStackView.isHidden = false
        }
    }
    
    @IBAction func swipeToShare(_ sender: UISwipeGestureRecognizer) {
        delegate?.viewControllerDidSwipeToShare(self)
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
        
        isAnimating = true
        if !begin {
            photoGridView.isHidden = false
            swipeToShareStackView.isHidden = false
        }
        // Initialize the animation duration to 1 sec
        
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        }) { (isCompleted) in
            if begin && isCompleted {
                self.photoGridView.isHidden = true
                self.swipeToShareStackView.isHidden = true
            }
          self.isAnimating = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoGridView.invalidateCollectionViewLayout()
    }
    
    func set(image: UIImage, indexPath: IndexPath) {
        photoGridView.set(image: image, indexPath: indexPath)
    }
    
    func set(layoutType: LayoutType) {
        photoGridView.layoutType = layoutType
    }
    
    func displayPhotoServiceDeniedAuthorizationMessage(){
        let messageAlert = UIAlertController(title: "Photo Library", message: "Authorization Denied", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.viewControllerDidPressOpenSettings(self)
        })
        messageAlert.addAction(cancelAction)
        messageAlert.addAction(settingsAction)
        present(messageAlert, animated: true, completion: nil)
    }
}

extension ViewController: FooterViewDelegate {
    
    func footerViewDidSelect(_ footerView: FooterView, indexPath: IndexPath) {
        delegate?.viewController(self, didSelectLayoutAt: indexPath)
    }
}

extension ViewController: PhotoGridViewDelegate {
    
    func photoGridViewDidSelect(_ photoGridView: PhotoGridView, indexPath: IndexPath) {
        delegate?.viewController(self, didSelectPhotoAt: indexPath)
    }
}
