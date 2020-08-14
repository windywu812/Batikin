//
//  UserDefault.swift
//  Batikin
//
//  Created by Windy on 14/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit

struct UserDefault {
    
    static var hasLaunched: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "hasLaunched")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hasLaunched")
        }
    }
    
}
