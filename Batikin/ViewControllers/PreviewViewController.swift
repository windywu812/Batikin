//
//  PreviewViewController.swift
//  Batikin
//
//  Created by Windy on 16/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    weak var collectionView: UICollectionView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        view.backgroundColor = UIColor(named: CustomColor.canvasBackground.color)
        
        self.navigationItem.title = "Preview"
        
        let buttonDismiss = UIButton(type: .system)
        buttonDismiss.setImage(UIImage(systemName: "xmark"), for: .normal)
        buttonDismiss.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        buttonDismiss.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonDismiss)
        buttonDismiss.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        buttonDismiss.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = "Preview your Batik"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: buttonDismiss.bottomAnchor, constant: 16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        self.collectionView = collectionView
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, environment) ->
            NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.3333), heightDimension: .fractionalWidth(0.3333)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
                        
            return section
        }
    }
    
}

extension PreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        cell.imageView.image = self.image
        
        return cell
    }
    
}
