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
            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
            let image = renderer.image { ctx in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
            
            delegate?.photoShareServiceWillDisplayShareSheet(self)
            
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList]
            
            activityViewController.completionWithItemsHandler = { [weak self] (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
                guard let self = self else { return }
                self.delegate?.photoShareServiceDidDisplayShareSheet(self)
            }
            
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}
