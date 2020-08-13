//
//  UIView+Extension.swift
//  Batikin
//
//  Created by Windy on 13/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit

extension UIView {
    
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    struct Holder {
        static var isflip: Bool = false
    }
    
    var isFlip: Bool {
        get {
            return Holder.isflip
        }
        set(newValue) {
            Holder.isflip = newValue
        }
    }
    
}
