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
    }
}

extension LogicController: PhotoLibraryServiceDelegate {
    
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
    
    func viewControllerDidSelect(_ viewController: ViewController, indexPath: IndexPath) {
        layoutType = LayoutType.allCases[indexPath.row]
    }
}
