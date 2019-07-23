//
//  PhotoShareService.swift
//  Instagrid
//
//  Created by Claire on 23/07/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

protocol PhotoShareServiceDelegate: class {
    
    func willTakeImage() -> UIView
    
    func willDisplayShareSheet()
    
    func didDisplayShareSheet()
}

class PhotoShareService {
    
    weak var delegate: PhotoShareServiceDelegate?
    
    func start(viewController: UIViewController) {
        if let view = delegate?.willTakeImage(){
            UIGraphicsBeginImageContext(view.bounds.size)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            guard let jpgImage = image.jpegData(compressionQuality: 1.0) else {
                //TODO: handle error
                return
            }
            
            delegate?.willDisplayShareSheet()
            
            let activityViewController = UIActivityViewController(activityItems: [jpgImage], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList]
            
            activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in

                self.delegate?.didDisplayShareSheet()
            }
            
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}
