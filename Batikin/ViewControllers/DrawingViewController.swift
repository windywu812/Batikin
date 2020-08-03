//
//  DrawingViewController.swift
//  Batikin
//
//  Created by Windy on 29/07/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var shapeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSegmentedControl()
    }
    
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
