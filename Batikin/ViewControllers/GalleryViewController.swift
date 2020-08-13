//
//  ViewController.swift
//  Batikin
//
//  Created by Windy on 28/07/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    weak var collectionView: UICollectionView!
    
    var batiks: [BatikModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        CoreDataServices.readData { (result) in
            self.batiks = result
        }
        
        collectionView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        view.backgroundColor = UIColor(named: CustomColor.canvasBackground.color)
        collectionView.backgroundColor = UIColor(named: CustomColor.canvasBackground.color)
    }
    
    private func setupCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: CustomColor.galleryBackground.rawValue)
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: Constant.customCollectionViewCell)
        collectionView.register(MyHeaderCell.self, forSupplementaryViewOfKind: Constant.headerCell, withReuseIdentifier: Constant.headerCell)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.collectionView = collectionView
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, environment) ->
            NSCollectionLayoutSection? in
          
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5)))
            item.contentInsets.bottom = 16
            item.contentInsets.trailing = 20
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = 20
            section.contentInsets.top = 20
            
            if self.batiks.isEmpty {
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48)), elementKind: Constant.headerCell, alignment: .topLeading)
                ]
            }
            return section
        }
    }
    
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return batiks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.customCollectionViewCell, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        let imageData = batiks[indexPath.row].imageBatik
        cell.imageView.image = UIImage(data: imageData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constant.headerCell, for: indexPath) as? MyHeaderCell else { return UICollectionReusableView() }
        if indexPath.section == 0 {
            if self.batiks.isEmpty {
                header.title.text = NSLocalizedString("Create your Batik", comment: "")
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SelectedStoryboard") as! SelectedViewController
        vc.batik = batiks[indexPath.row]
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
