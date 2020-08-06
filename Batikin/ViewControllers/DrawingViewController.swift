//
//  DrawingViewController.swift
//  Batikin
//
//  Created by Windy on 29/07/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit
import Macaw

class DrawingViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var shapeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    let canvasView : UIView = UIView(frame:CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNewView()
        setupScrollView()

        setupNavigationBar()
        setupSegmentedControl()
    }
    

    // MARK: ---- Artboard --------
    private func setupScrollView() {
        scrollView.backgroundColor = UIColor.white
        scrollView.delegate = self
        scrollView.delegate = self
        scrollView.contentOffset = CGPoint(x: 500, y: 200)
        scrollView.minimumZoomScale = 1.1
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.zoomScale = 1
    }
    
    private func setupNewView() {
        scrollView.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.backgroundColor = .yellow
        
        canvasView.widthAnchor.constraint(equalToConstant: scrollView.bounds.width).isActive = true
        canvasView.heightAnchor.constraint(equalToConstant:scrollView.bounds.height).isActive = true

        scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo:scrollView.frameLayoutGuide.widthAnchor).isActive = true
        scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo:scrollView.frameLayoutGuide.heightAnchor).isActive = true
        
        canvasView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor).isActive = true
        canvasView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor).isActive = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvasView
    }
    
    // MARK: ----- Segmented & Navbar ------

    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    private func setupSegmentedControl() {
        shapeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        shapeSegmentedControl.backgroundColor = #colorLiteral(red: 0.8946712613, green: 0.6200030446, blue: 0.617100358, alpha: 1)
        shapeSegmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.7618311048, green: 0.1676428616, blue: 0.2137463689, alpha: 1)
    }
    
}

// MARK: ------ Collection View -----------

var imageArray = ["motif_flower_a","motif_flower_b","motif_leaf_a","motif_leaf_b","motif_leaf_b","motif_leaf_b","motif_leaf_b","motif_leaf_b","motif_leaf_b"]

extension DrawingViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BtnCollectionViewCell", for: indexPath) as? BtnCollectionViewCell else { return UICollectionViewCell() }
        cell.btnImg.setBackgroundImage(UIImage(named: imageArray[indexPath.row]), for: .normal)
        return cell
    }
    
}
