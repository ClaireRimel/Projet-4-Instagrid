//
//  PhotoShareService.swift
//  Instagrid
//
//  Created by Claire on 23/07/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

protocol PhotoShareServiceDelegate: class {
    
    func photoShareServiceWillTakeImage(_ photoShareService: PhotoShareService) -> UIView
    
    func photoShareServiceWillDisplayShareSheet(_ photoShareService: PhotoShareService)
    
    func photoShareServiceDidDisplayShareSheet(_ photoShareService: PhotoShareService)
}

class PhotoShareService {
    
    weak var delegate: PhotoShareServiceDelegate?
    
    func start(viewController: UIViewController) {
        if let view = delegate?.photoShareServiceWillTakeImage(self) {
            UIGraphicsBeginImageContext(view.bounds.size)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            guard let jpgImage = image.jpegData(compressionQuality: 1.0) else {
                //TODO: handle error
                return
            }
            
            delegate?.photoShareServiceWillDisplayShareSheet(self)
            
            let activityViewController = UIActivityViewController(activityItems: [jpgImage], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList]
            
            activityViewController.completionWithItemsHandler = { [weak self] (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
                guard let self = self else { return }
                self.delegate?.photoShareServiceDidDisplayShareSheet(self)
            }
            
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}
