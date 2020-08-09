//
//  Shape.swift
//  Batikin
//
//  Created by Windy on 09/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import Foundation

class ShapeModel {
    
    var mainShape: [String] = []
    var fillerShape: [String] = []
    var isenShape: [String] = []
    
    init() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("main") {
                mainShape.append(item.removeExtension())
            } else if item.hasPrefix("filler") {
                fillerShape.append(item.removeExtension())
            } else if item.hasPrefix("isen") {
                isenShape.append(item.removeExtension())
            }
        }
    }
    
}

extension String {
    func removeExtension() -> String  {
        return self.replacingOccurrences(of: ".svg", with: "")
    }
}
