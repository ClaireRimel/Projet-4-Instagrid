//
//  LogicController.swift
//  Instagrid
//
//  Created by Claire on 28/07/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

class LogicController {
    
    let photoLibraryService = PhotoLibraryService()
    let photoShareService = PhotoShareService()
    let viewController: ViewController
        
    var layoutType: LayoutType = .oneTopTwoBottom {
        didSet {
            viewController.set(layoutType: layoutType)
        }
    }

    init(viewController: ViewController) {
        self.viewController = viewController
        photoLibraryService.delegate = self
        photoShareService.delegate = self
        viewController.delegate = self
    }
}

extension LogicController: PhotoLibraryServiceDelegate {
    
    func photoLibraryServiceAuthorizationDenied(_ photoLibraryService: PhotoLibraryService) {
        viewController.displayPhotoServiceDeniedAuthorizationMessage()
    }
    
    func photoLibraryService(_ photoLibraryService: PhotoLibraryService, didChoose image: UIImage, at indexPath: IndexPath) {
        viewController.set(image: image, indexPath: indexPath)
    }
}

extension LogicController: PhotoShareServiceDelegate {
    
    func photoShareServiceWillTakeImage(_ photoShareService: PhotoShareService) -> UIView {
        return viewController.photoGridView
    }
    
    func photoShareServiceWillDisplayShareSheet(_ photoShareService: PhotoShareService) {
        viewController.shareAnimation(begin: true)
    }
    
    func photoShareServiceDidDisplayShareSheet(_ photoShareService: PhotoShareService) {
        viewController.shareAnimation(begin: false)
    }
}

extension LogicController: ViewControllerDelegate {
    
    func viewControllerDidPressOpenSettings(_ viewController: ViewController) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    func viewControllerDidSwipeToShare(_ viewController: ViewController) {
        photoShareService.start(viewController: viewController)
    }
    
    func viewController(_ viewController: ViewController, didSelectLayoutAt indexPath: IndexPath) {
        layoutType = LayoutType.allCases[indexPath.row]
    }
    
    func viewController(_ viewController: ViewController, didSelectPhotoAt indexPath: IndexPath) {
        photoLibraryService.photoAccess(indexPath: indexPath,
                                        viewController: viewController)
    }
}
