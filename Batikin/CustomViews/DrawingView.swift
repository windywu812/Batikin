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
    
    var lastRotation: CGFloat = 0
    
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
            
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateShape(_:)))
            selectedView?.addGestureRecognizer(rotateGesture)
        }
        
        previousView = selectedView
        
        let myObjects = ["drawingView": self, "selectedView": selectedView]
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name.sendViews , object: myObjects)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let position = touches.first?.location(in: self) else { return }
        
        guard let selectedView = selectedView as? MacawView else { return }
        
        if isDragging {
            if !self.bounds.contains(position) {
                return
            } else {
                let x = position.x - selectedView.bounds.width / 2
                let y = position.y - selectedView.bounds.height / 2
                
                selectedView.transform = .init(translationX: x, y: y)
//                selectedView.transform = selectedView.transform.translatedBy(x: x, y: y)
                

            }
        } else {
            isDragging = false
        }
    }
    
    @objc private func scaleShape(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            guard let newBounds = selectedView?.bounds.applying(.init(scaleX: sender.scale, y: sender.scale)) else { return }
            selectedView?.bounds = newBounds
            sender.scale = 1.0
        }
    }

    @objc private func rotateShape(_ sender: UIRotationGestureRecognizer) {
        
       var originalRotation = CGFloat()
        if sender.state == .began || sender.state == .changed {
            print("sender.rotation: \(sender.rotation)")
            // sender.rotation renews everytime the rotation starts
            // delta value but not absolute value
            sender.rotation = lastRotation
            
            // the last rotation is the relative rotation value when rotation stopped last time,
            // which indicates the current rotation
            originalRotation = sender.rotation
                        
            let newRotation = sender.rotation + originalRotation
            print(newRotation)
            print(sender.rotation, "123")
            
            selectedView?.transform = selectedView!.transform.rotated(by: sender.rotation)
//            selectedView?.transform = .init(rotationAngle: sender.rotation)
            
            lastRotation = sender.rotation
            sender.rotation = 0
            
            
        } else if sender.state == .ended {
            // Save the last rotation
            lastRotation = sender.rotation
        }
    }
    
}

extension Notification.Name {
    static let sendViews = Notification.Name("sendViews")
}
