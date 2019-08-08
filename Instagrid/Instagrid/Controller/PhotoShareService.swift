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
    
    //Takes a screenshot of a given UIView (the photo grid which will be provided by the delegate) and then presents the iOS Share sheet attaching the screenshot as an image.
    func start(viewController: UIViewController) {
        if let view = delegate?.photoShareServiceWillTakeImage(self) {
            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
            let image = renderer.image { ctx in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
            
            //Communicates the delegate that the share sheet will be displayed. We use it to trigger a photo grid animation on a View level
            delegate?.photoShareServiceWillDisplayShareSheet(self)
            
            //Instanciates the share sheet object, represented by UIActivityViewController
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList]
            
            //This block of code gets executed when the Share sheet is dimissed. This happens after
            //1. successfully sharing the image
            //2. there's a share failure
            //3. the user cancels sharing the image
            activityViewController.completionWithItemsHandler = { [weak self] (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
                guard let self = self else { return }
                //Communicates the delegate that the share sheet will be dismissed. We use it to trigger a photo grid animation on a View level
                self.delegate?.photoShareServiceDidDisplayShareSheet(self)
            }
            
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}
