//
//  ViewController.swift
//  Batikin
//
//  Created by Windy on 28/07/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "My Batiks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(handlePlus)),
            UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(handleSelect))
        ]
    }
    
    func addFuction() {
        
    }

//    @objc func handlePlus() {
//
//    }
    
    @objc func handleSelect() {
        
    }

}

