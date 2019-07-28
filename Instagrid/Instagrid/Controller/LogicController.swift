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
    
    func didChoose(image: UIImage, indexPath: IndexPath) {
        viewController.set(image: image, indexPath: indexPath)
    }
}

extension LogicController: PhotoShareServiceDelegate {
    
    func willTakeImage() -> UIView {
        return viewController.photoGridView
    }
    
    func willDisplayShareSheet() {
        viewController.shareAnimation(begin: true)
    }
    
    func didDisplayShareSheet() {
        viewController.shareAnimation(begin: false)
    }
}

extension LogicController: ViewControllerDelegate {
    
    func didSelect(indexPath: IndexPath) {
        layoutType = LayoutType.allCases[indexPath.row]
    }
}
