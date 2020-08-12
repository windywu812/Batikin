//
//  ColorConvertor.swift
//  Color Slider
//
//  Created by Omar Tan Johan Tan on 11/08/2020.
//  Copyright © 2020 Omar Tan Johan Tan. All rights reserved.
//
//  Adapted from https://gist.github.com/miguelbermudez/1132815
//

import CoreGraphics
import UIKit

struct ColorConvertor {
    /*
     * Converts an RGB color value to HSV. Conversion formula
     * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
     * Assumes r, g, and b are contained in the set [0, 255] and
     * returns h, s, and v in the set [0, 1].
     */
    func RGBtoHSB(r:Float, g:Float, b:Float) -> (h:CGFloat, s:CGFloat, b:CGFloat) {
        let r = r / 255
        let g = g / 255
        let b = b / 255
        
        let max = Swift.max(r, g, b), min = Swift.min(r, g, b)
        
        let brightness:Float = max
        var hue:Float = max, saturation:Float = max
    
        let d = max - min
        saturation = max == 0 ? 0 : d / max
        
        if max == min {
            hue = 0
        } else {
            switch max {
            case r:
                hue = (g - b) / d + (g < b ? 6 : 0)
                break
            case g:
                hue = (b - r) / d + 2
                break
            case b:
                hue = (r - g) / d + 4
            default:
                break
            }
            hue /= 6
        }

        return (
            CGFloat(hue).roundToDecimal(3),
            CGFloat(saturation).roundToDecimal(3),
            CGFloat(brightness).roundToDecimal(3)
        )
    }
    
    /*
     * Converts an HSV color value to RGB. Conversion formula
     * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
     * Assumes h, s, and v are contained in the set [0, 1] and
     * returns r, g, and b in the set [0, 255].
     */
    func HSBtoRGB(h:CGFloat, s:CGFloat, b:CGFloat) -> (r:Int, g:Int, b:Int) {
        var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0
        
        let i = floor(h * 6)
        let f = h * 6 - i
        let p = b * (1 - s)
        let q = b * (1 - f * s)
        let t = b * (1 - (1 - f) * s)
        
        switch i.truncatingRemainder(dividingBy: 6) {   // need to confirm if this the same as modulo
        case 0: red = b; green = t; blue = p; break
        case 1: red = q; green = b; blue = p; break
        case 2: red = p; green = b; blue = t; break
        case 3: red = p; green = q; blue = b; break
        case 4: red = t; green = p; blue = b; break
        case 5: red = b; green = p; blue = q; break
        default:
            break
        }
        
        return (Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}

extension CGFloat {
    func roundToDecimal(_ fractionDigits: Int) -> CGFloat {
        let multiplier = pow(10, Double(fractionDigits))
        return CGFloat(Darwin.round(Double(self) * multiplier) / multiplier)
    }
}
