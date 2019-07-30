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
}

class PhotoLibraryService: NSObject {
    
    private var indexPath: IndexPath?
    
    weak var delegate: PhotoLibraryServiceDelegate?
 
    func photoAccess(indexPath: IndexPath, viewController: UIViewController) {
        let sourceType: UIImagePickerController.SourceType = .photoLibrary
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    print ("It's authorized")
                    // recursion
                    self.photoAccess(indexPath: indexPath,
                                     viewController: viewController)
                }
            }
            
        case .authorized:
            self.indexPath = indexPath
            
            DispatchQueue.main.async {
                let controller = UIImagePickerController()
                controller.sourceType = sourceType
                controller.delegate = self
                viewController.present(controller, animated: true, completion: nil)
            }
     
        case .denied:
            print("Acces Photo denied")
            
        default:
            break
        }
        
    }
}

extension PhotoLibraryService: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as! UIImage
        
        if let indexPath = indexPath {
            delegate?.photoLibraryService(self, didChoose: image, at: indexPath)
        }
    }
}

extension PhotoLibraryService: UINavigationControllerDelegate {}
