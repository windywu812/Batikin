//
//  DrawingViewController.swift
//  Batikin
//
//  Created by Windy on 29/07/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit
import Macaw

class DrawingViewController: UIViewController {
    
    @IBOutlet weak var shapeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var drawingView: UIView!
    @IBOutlet weak var drawingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawingViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawingViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawingViewTrailingConstraint: NSLayoutConstraint!
    
    var selectedView: UIView?
    var isDragging: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSegmentedControl()
    }
    
    // MARK: Navbar
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.right.circle"), style: .plain, target: self, action: #selector(handleRedo)),
            UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.left.circle"), style: .plain, target: self, action: #selector(handleUndo))
        ]
    }
    
    @objc private func handleRedo() {
        
    }
    
    @objc private func handleUndo() {
        
    }
    
    // MARK: Segmented Control
    private func setupSegmentedControl() {
        shapeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        shapeSegmentedControl.backgroundColor = #colorLiteral(red: 0.8946712613, green: 0.6200030446, blue: 0.617100358, alpha: 1)
        shapeSegmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.7618311048, green: 0.1676428616, blue: 0.2137463689, alpha: 1)
    }
    
}

// MARK: Collection View
extension DrawingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BtnCollectionViewCell", for: indexPath) as? BtnCollectionViewCell else { return UICollectionViewCell() }
        cell.btnImg.setBackgroundImage(UIImage(named: imageArray[indexPath.row]), for: .normal)
        return cell
    }
    
}

// MARK: DrawingScreen Logic
extension DrawingViewController: UIScrollViewDelegate {
    
    func updateMinZoomScaleForSize(_ size:CGSize) {
        let widthScale = size.width / drawingView.bounds.width
        let heightScale = size.height / drawingView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    func updateConstraintsForSize(_ size:CGSize){
        
        var yOffset: CGFloat = 0
        
        if size.height >= 896 {
            yOffset = max(0, (size.height - drawingView.frame.height) / 4.5)
        } else {
            yOffset = max(0, (size.height - drawingView.frame.height) / 10)
        }
        
        drawingViewTopConstraint.constant = yOffset
        drawingViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - drawingView.frame.width)/4.5)
        drawingViewLeadingConstraint.constant = xOffset
        drawingViewTrailingConstraint.constant = xOffset
        view.layoutIfNeeded()
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return drawingView
    }
    
}
