//
//  LogicController.swift
//  Instagrid
//
//  Created by Claire on 28/07/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

// Does the connection between photoLibraryService, photoShareService and viewController
class LogicController {
    
    let photoLibraryService = PhotoLibraryService()
    let photoShareService = PhotoShareService()
    let viewController: ViewController
    
    //Represents the current selected layout type by the user
    var layoutType: LayoutType = .oneTopTwoBottom {
        //Via property observer, when the value changes, it tells the View Controller to update its layout display (photo grid and selected layout)
        didSet {
            viewController.set(layoutType: layoutType)
        }
    }

    //When the object is created we set it as the delegate of the View and the services
    init(viewController: ViewController) {
        self.viewController = viewController
        photoLibraryService.delegate = self
        photoShareService.delegate = self
        viewController.delegate = self
    }
}

extension LogicController: PhotoLibraryServiceDelegate {
    
    //Tells the View Controller to display an error message
    func photoLibraryServiceAuthorizationDenied(_ photoLibraryService: PhotoLibraryService) {
        viewController.displayPhotoServiceDeniedAuthorizationMessage()
    }
    
    //Tells the View Controller to display the selected image from the photo library in the photo grid on the corresponding index path
    func photoLibraryService(_ photoLibraryService: PhotoLibraryService, didChoose image: UIImage, at indexPath: IndexPath) {
        viewController.set(image: image, indexPath: indexPath)
    }
}

extension LogicController: PhotoShareServiceDelegate {
    
    //Tells the Photo Service to take a screenshot to the photo grid view
    func photoShareServiceWillTakeImage(_ photoShareService: PhotoShareService) -> UIView {
        return viewController.photoGridView
    }
    
    //Tells the View Controller to start an animation triggered by the visibility of the Share sheet
    func photoShareServiceWillDisplayShareSheet(_ photoShareService: PhotoShareService) {
        viewController.shareAnimation(begin: true)
    }
    
    func photoShareServiceDidDisplayShareSheet(_ photoShareService: PhotoShareService) {
        viewController.shareAnimation(begin: false)
    }
}

extension LogicController: ViewControllerDelegate {
    
    func viewControllerDidPressOpenSettings(_ viewController: ViewController) {
        //Opens iOS Settings for the user to be able to change the photo library authorization status
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    func viewControllerDidSwipeToShare(_ viewController: ViewController) {
        photoShareService.start(viewController: viewController)
    }
    
    //Stores the current layout selection by the user in the layoutType property
    func viewController(_ viewController: ViewController, didSelectLayoutAt indexPath: IndexPath) {
        layoutType = LayoutType.allCases[indexPath.row]
    }
    
    func viewController(_ viewController: ViewController, didSelectPhotoAt indexPath: IndexPath) {
        photoLibraryService.photoAccess(indexPath: indexPath,
                                        viewController: viewController)
    }
}
