//
//  Date+Extension.swift
//  Batikin
//
//  Created by Windy on 13/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        return formatter.string(from: self)
    }
    
}
