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

    weak var delegate: ViewControllerDelegate?
    
    //Represents if the Share sheet is currently visible
    var isSharing: Bool = false
    
    //Represents an active photo grid animation triggered by the swipe gesture
    var isAnimating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        footerView.delegate = self
        photoGridView.delegate = self

        // We initially set the number of touches required by the swipe gesture and also its direction based on the current device orientation.
        swipeGesture.numberOfTouchesRequired = 1
        didChangeDeviceOrientation()
        
        // We subscribe this class to the Notification Center, triggering a call to the function "updateSwipeOrientation" when the device orientation changes
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        
//        //Tells the delegate the view was loaded on memory
//        delegate?.viewControllerDidLoad(self)
    }
    
    @objc func didChangeDeviceOrientation() {
        //We use the event to set the correct swipeGesture direction.
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown, .faceUp, .faceDown:
            swipeGesture.direction = .up
        case .landscapeLeft, .landscapeRight:
            swipeGesture.direction = .left
        default:
            break
        }
        
        // Notify the footerView that the device orientation changes
        footerView.didChangeDeviceOrientation()
        
        //If the device orientation changes while there is an active share animation, the animation gets cancelled to avoid unwanted displaying animations.
        if isAnimating {
            photoGridView.isHidden = true
            swipeToShareStackView.isHidden = true
            photoGridView.layer.removeAllAnimations()
            swipeToShareStackView.layer.removeAllAnimations()
        }
        
        //If the share sheet is visible, it changes the position of the photo grid to be outside of the screen depending on the new device orientation
        if isSharing {
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown, .faceUp, .faceDown:
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
        //Otherwise, forces the photo grid to reappear in the center of the screen
        } else {
            photoGridCenterXConstraint.constant = 0
            photoGridCenterYConstraint.constant = 0
            view.layoutIfNeeded()
            
            photoGridView.isHidden = false
            swipeToShareStackView.isHidden = false
        }
    }
    
    //Tells the delegate that the user performed the defined share swipe gesture
    @IBAction func swipeToShare(_ sender: UISwipeGestureRecognizer) {
        delegate?.viewControllerDidSwipeToShare(self)
    }
    
    // In the case of device orientation changed during the share animation, we will change the "hidden" position of the photoGrid. 
    func shareAnimation(begin: Bool) {
        //We store...
        isSharing = begin
        
        //Sets a offset, depending on the device orientation, to animate the photo grid outside the screen
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown, .faceUp, .faceDown:
            photoGridCenterYConstraint.constant = begin ? -1000 : 0
        case .landscapeLeft, .landscapeRight:
            photoGridCenterXConstraint.constant = begin ? -1000 : 0
            
            //Apparently this case appears while first launching the app on simulator if it has the portrait orientation set.
        case .unknown:
            photoGridCenterYConstraint.constant = begin ? -1000 : 0
            
        default:
            break
        }
        
        //Starts the photo grid animation, setting the flag to true
        isAnimating = true
        
        if !begin {
            photoGridView.isHidden = false
            swipeToShareStackView.isHidden = false
        }
        
        //Animates the photo grid position change during 1 sec
        UIView.animate(withDuration: 1.0, animations: {
            //Updates the photo grid constraints
            self.view.layoutIfNeeded()
        }) { (isCompleted) in
            //If corresponds to the initial animation and if it was correctly finished (example: not interrumpted by a device orientation change), it hides both elements
            if begin && isCompleted {
                self.photoGridView.isHidden = true
                self.swipeToShareStackView.isHidden = true
            }
            
            //We set the global animation flag back to false as the animation finished
            self.isAnimating = false
        }
    }
    
    //Reloads the photoGridView after a device orientation change, which triggers this function
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoGridView.invalidateCollectionViewLayout()
    }
    
    //Tells the photo grid to display an image in the specified indexpath
    func set(image: UIImage, indexPath: IndexPath) {
        photoGridView.set(image: image, indexPath: indexPath)
    }
    
    //Tells the photo grid to display the specified layout
    func set(layoutType: LayoutType) {
        photoGridView.layoutType = layoutType
    }
    
    func displayPhotoServiceDeniedAuthorizationMessage(){
        let messageAlert = UIAlertController(title: "Photo Library",
                                             message: "Authorization Denied",
                                             preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        let settingsAction = UIAlertAction(title: "Settings",
                                           style: .default,
                                           handler: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.viewControllerDidPressOpenSettings(self)
        })
        
        messageAlert.addAction(cancelAction)
        messageAlert.addAction(settingsAction)
        present(messageAlert, animated: true, completion: nil)
    }
}

//By conforming to the FooterViewDelegate protocol, the FooterView tells the ViewController which layout was selected by the user, which it communicates to its delegate for logic handling
extension ViewController: FooterViewDelegate {
    
    func footerViewDidSelect(_ footerView: FooterView, indexPath: IndexPath) {
        delegate?.viewController(self, didSelectLayoutAt: indexPath)
    }
}

//By conforming to the PhotoGridViewDelegate protocol, the PhotoGridView tells the ViewController which photo cell was selected by the user, which it communicates to its delegate for logic handling
extension ViewController: PhotoGridViewDelegate {
    
    func photoGridViewDidSelect(_ photoGridView: PhotoGridView, indexPath: IndexPath) {
        delegate?.viewController(self, didSelectPhotoAt: indexPath)
    }
}
