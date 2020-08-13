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

    var previousView: UIView?
    var selectedView: UIView?
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        
        previousView?.layer.borderColor = UIColor.clear.cgColor
        selectedView = self.hitTest(position, with: nil)
                
        if selectedView != nil && selectedView != self {
            isDragging = true
        }
        
        if selectedView != self {
            selectedView?.layer.borderColor = UIColor(named: CustomColor.tintColor.rawValue)?.cgColor
            selectedView?.layer.borderWidth = 3
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleShape(_:)))
            selectedView?.addGestureRecognizer(pinchGesture)
            
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotatePiece(_:)))
            selectedView?.addGestureRecognizer(rotateGesture)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panPiece(_:)))
            selectedView?.addGestureRecognizer(panGesture)
        }
        
        previousView = selectedView
        
        let myObjects = ["drawingView": self, "selectedView": selectedView]
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name.sendViews , object: myObjects)
        }
        
    }
    
    @objc private func scaleShape(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            
            if let transform = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) {
                sender.view?.transform = transform
            }
            sender.scale = 1.0
        }
    }
    
    @objc func panPiece(_ gestureRecognizer: UIPanGestureRecognizer) {
        let piece = gestureRecognizer.view

        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: piece?.superview)
    
            piece?.center = CGPoint(x: (piece?.center.x ?? 0.0) + (translation.x ), y: (piece?.center.y ?? 0.0) + (translation.y ))
            gestureRecognizer.setTranslation(CGPoint.zero, in: piece?.superview)
        }
    }
    
    @objc func rotatePiece(_ gestureRecognizer: UIRotationGestureRecognizer) {
    
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            if let transform = gestureRecognizer.view?.transform.rotated(by: gestureRecognizer.rotation ) {
                gestureRecognizer.view?.transform = transform
            }
            gestureRecognizer.rotation = 0
        }
    }
    
}
