//
//  Image.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit

enum Image: String {
    case backgroundImage
    case background
    case launchScreen = "launch-screen"
    
    var value: UIImage {
        return UIImage(named: rawValue)!
    }
}
