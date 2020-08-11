//
//  CanvasView.swift
//  Batikin
//
//  Created by Windy on 07/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit
import Macaw

class DrawingView: UIView {
    
    var isDragging: Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }

        selectedView = self.hitTest(position, with: nil)
        
        if selectedView != nil && selectedView != self {
            isDragging = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        
        guard let selectedView = selectedView as? MacawView else { return }
//        print(selectedView.node)
        
        if isDragging {
            if !self.bounds.contains(position) {
                return
            } else {
                selectedView.transform = .init(translationX: position.x - selectedView.bounds.width / 2, y: position.y - selectedView.bounds.height / 2)
            }
        } else {
            isDragging = false
        }
    }
    
}
