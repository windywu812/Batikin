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
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var drawingView: UIView!
    @IBOutlet weak var drawingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawingViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawingViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawingViewTrailingConstraint: NSLayoutConstraint!
    
    var selectedView: UIView?
    var isDragging: Bool = false
    
    var shapeModel = ShapeModel()
    
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
        shapeSegmentedControl.backgroundColor = UIColor(named: Color.segmentBackground.rawValue)
        shapeSegmentedControl.selectedSegmentTintColor = UIColor(named: Color.tintColor.rawValue)
        
        bottomContainer.backgroundColor = UIColor.systemBackground
    }
    
    @IBAction func handleSegmentedControl(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
}

// MARK: Collection View
extension DrawingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch shapeSegmentedControl.selectedSegmentIndex {
        case 0:
            return shapeModel.mainShape.count
        case 1:
            return shapeModel.fillerShape.count
        case 2:
            return shapeModel.isenShape.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.shapeCollectionViewCell, for: indexPath) as? BtnCollectionViewCell else { return UICollectionViewCell() }
        
        switch shapeSegmentedControl.selectedSegmentIndex {
        case 0:
            cell.btnImg.fileName = shapeModel.mainShape[indexPath.row]
        case 1:
            cell.btnImg.fileName = shapeModel.fillerShape[indexPath.row]
        case 2:
            cell.btnImg.fileName = shapeModel.isenShape[indexPath.row]
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Do something if selected
        print("tap")
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
        scrollView.backgroundColor = UIColor(named: Color.canvasBackground.rawValue)
        view.backgroundColor = UIColor(named: Color.canvasBackground.rawValue)
        
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
