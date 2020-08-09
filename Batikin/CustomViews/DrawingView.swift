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
    
    var selectedView: UIView?
    var isDragging: Bool = false
    let drawingVC = DrawingViewController()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        
        selectedView = self.hitTest(position, with: nil)
        
        if selectedView != nil {
            isDragging = true
//            guard let macawView = selectedView as? MacawView else { return }
            //               updateStroke(node: macawView.node)
        } else {
            return
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        
        guard let selectedView = selectedView as? MacawView else { return }
        
        if isDragging {
            if !self.bounds.contains(position) {
                drawingVC.scrollView.isUserInteractionEnabled = false
                return
            } else {
                selectedView.transform = .init(translationX: position.x - selectedView.bounds.width / 2, y: position.y - selectedView.bounds.height / 2)
            }
        } else {
            drawingVC.scrollView.isUserInteractionEnabled = true
            isDragging = false
        }
    }
    
}