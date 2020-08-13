//
//  Constant.swift
//  Batikin
//
//  Created by Windy on 03/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit

struct Constant {
    
    static let collectionCell = "collectionCell"
    static let headerCell = "headerCell"
    static let shapeCollectionViewCell = "ShapeCollectionViewCell"
    static let customCollectionViewCell = "CustomCollectionViewCell"
    
    static let entityName = "Batik"
    static var idBatik = "idBatik"
    static let nameBatik = "nameBatik"
    static let imageBatik = "imageBatik"
}

enum CustomColor: String {
    case galleryBackground
    case segmentBackground
    case canvasBackground
    case tintColor 
    
    var color: String {
        switch self {
        case .galleryBackground:
            return "galleryBackground"
        case .segmentBackground:
            return "segmentBackground"
        case .canvasBackground:
            return "canvasBackground"
        case .tintColor:
            return "tintColor"
        }
    }
}
