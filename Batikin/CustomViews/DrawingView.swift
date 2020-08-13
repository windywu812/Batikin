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
    
    var panGesture: UIPanGestureRecognizer?
    var pinchGesture: UIPinchGestureRecognizer?
    var rotateGesture: UIRotationGestureRecognizer?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        
        previousView?.layer.borderColor = UIColor.clear.cgColor
        selectedView = self.hitTest(position, with: nil)
        
        if selectedView != nil && selectedView != self {
            isDragging = true
            selectedView?.layer.borderColor = UIColor(named: CustomColor.tintColor.color)?.cgColor
            selectedView?.layer.borderWidth = 3
        }
        
        if selectedView != self {
            pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleShape(_:)))
            selectedView?.addGestureRecognizer(pinchGesture!)
            
            rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotatePiece(_:)))
            selectedView?.addGestureRecognizer(rotateGesture!)
            
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(panPiece(_:)))
            selectedView?.addGestureRecognizer(panGesture!)
        }
        
        let myObjects = ["drawingView": self, "selectedView": selectedView]
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name.sendViews , object: myObjects)
        }
        previousView = selectedView
        
    }
    
    @objc private func scaleShape(_ sender: UIPinchGestureRecognizer) {
        
        if selectedView == self {
            return
        }
        
        if sender.state == .began || sender.state == .changed {
            if let transform = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) {
                sender.view?.transform = transform
            }
            sender.scale = 1.0
        } else if sender.state == .ended {
            sender.view?.removeGestureRecognizer(pinchGesture!)
        }
    }
    
    @objc func panPiece(_ sender: UIPanGestureRecognizer) {
        
        if selectedView == self {
            return
        }
        
        let piece = sender.view
        
        if sender.state == .began || sender.state == .changed {
            
            let translation = sender.translation(in: piece?.superview)
          
            piece?.center = CGPoint(x: (piece?.center.x ?? 0.0) + (translation.x ), y: (piece?.center.y ?? 0.0) + (translation.y ))
            sender.setTranslation(CGPoint.zero, in: piece?.superview)
        } else if sender.state == .ended {
            sender.view?.removeGestureRecognizer(panGesture!)
        }
    }
    
    @objc func rotatePiece(_ gestureRecognizer: UIRotationGestureRecognizer) {
        
        if selectedView == self {
            return
        }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            if gestureRecognizer.view?.isFlip == true {
                if let transform = gestureRecognizer.view?.transform.rotated(by: -gestureRecognizer.rotation ) {
                    gestureRecognizer.view?.transform = transform
                }
                gestureRecognizer.rotation = 0
            } else {
                if let transform = gestureRecognizer.view?.transform.rotated(by: gestureRecognizer.rotation ) {
                    gestureRecognizer.view?.transform = transform
                }
                gestureRecognizer.rotation = 0
            }
        } else if gestureRecognizer.state == .ended {
            gestureRecognizer.view?.removeGestureRecognizer(rotateGesture!)
        }
    }
    
}
