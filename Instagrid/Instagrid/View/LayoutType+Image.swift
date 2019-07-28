//
//  LayoutType+Image.swift
//  Instagrid
//
//  Created by Claire on 28/07/2019.
//  Copyright © 2019 Claire Sivadier. All rights reserved.
//

import UIKit

// As part of the presentation logic, we will extend the functionality of the LayoutType type by adding an image property which provides an unique image for each of its cases
extension LayoutType {
    
    var image: UIImage {
        switch self {
        case .oneTopTwoBottom:
            return UIImage(named: "Layout-1")!
        case .twoTopOneBottom:
            return UIImage(named: "Layout-2")!
        case .twoTopTwoBottom:
            return UIImage(named: "Layout-3")!
        case .threeTopThreeCenterThreeBottom:
            return UIImage(named: "Layout-4")!
        }
    }
}
