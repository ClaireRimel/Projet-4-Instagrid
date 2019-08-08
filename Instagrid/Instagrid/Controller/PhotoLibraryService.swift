//
//  PhotoLibraryService.swift
//  Instagrid
//
//  Created by Claire on 22/07/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit
import Photos

protocol PhotoLibraryServiceDelegate: class {
    
    func photoLibraryService(_ photoLibraryService: PhotoLibraryService, didChoose image: UIImage, at indexPath: IndexPath)
    
    func photoLibraryServiceAuthorizationDenied(_ photoLibraryService: PhotoLibraryService)
}

class PhotoLibraryService: NSObject {
    
    private var indexPath: IndexPath?
    
    weak var delegate: PhotoLibraryServiceDelegate?
 
    // describes the behavour of each case
    func photoAccess(indexPath: IndexPath, viewController: UIViewController) {
        let sourceType: UIImagePickerController.SourceType = .photoLibrary
        
        //First we check the current authorization status
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            //It means we have not asked yet the user to access the photo library, so we will start the authorization request
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    print ("It's authorized")
                    // By using recursion, if the user provides authorization, we will call again this function as the status will now be "authorized", so the Photo Library will be displayed automatically after the user provides access to it.
                    self.photoAccess(indexPath: indexPath,
                                     viewController: viewController)
                }
            }
            
        case .authorized:
            //We display the photo library, storing the photo grid's index path where we will need to set the image chosen by the user later
            self.indexPath = indexPath
            
            //All View presentations needs to be performed in the main thread.
            DispatchQueue.main.async {
                let controller = UIImagePickerController()
                controller.sourceType = sourceType
                controller.delegate = self
                viewController.present(controller, animated: true, completion: nil)
            }
     
        case .denied:
            //We will notify the delegate in order to display an error message to the user.
            print("Acces Photo denied")
            delegate?.photoLibraryServiceAuthorizationDenied(self)
            
        default:
            break
        }
    }
}

//By making the class conform to the UIImagePickerControllerDelegate protocol, we allow the class to receive the image selected by the user in the Photo Library.
extension PhotoLibraryService: UIImagePickerControllerDelegate {
    
    // Sends the picture chosen to the LogicController via delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as! UIImage
        
        if let indexPath = indexPath {
            delegate?.photoLibraryService(self, didChoose: image, at: indexPath)
        }
    }
}

//This is required to display the UIImagePickerController
extension PhotoLibraryService: UINavigationControllerDelegate {}
