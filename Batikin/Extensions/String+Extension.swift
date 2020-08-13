//
//  String+Extension.swift
//  Batikin
//
//  Created by Windy on 13/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import Foundation

extension String {
    func removeExtension() -> String  {
        return self.replacingOccurrences(of: ".svg", with: "")
    }
}
