//
//  SelectedViewController.swift
//  Batikin
//
//  Created by Windy on 13/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit

class SelectedViewController: UIViewController {
    
    var batikView: UIImageView!
    var batik: BatikModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        view.backgroundColor = UIColor(named: CustomColor.canvasBackground.color)
    }
    
    private func setupView() {
        batikView = UIImageView()
        batikView.image = UIImage(data: batik!.imageBatik)
        view.addSubview(batikView)
        
        batikView.translatesAutoresizingMaskIntoConstraints = false
        batikView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        batikView.heightAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        batikView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        batikView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16).isActive = true
        
        let buttonDismiss = UIButton(type: .system)
        buttonDismiss.setImage(UIImage(systemName: "xmark"), for: .normal)
        buttonDismiss.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        buttonDismiss.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonDismiss)
        buttonDismiss.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        buttonDismiss.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        let buttonDelete = UIButton(type: .system)
        buttonDelete.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
        buttonDelete.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        buttonDelete.translatesAutoresizingMaskIntoConstraints = false
        buttonDelete.widthAnchor.constraint(equalToConstant: 44).isActive = true
        buttonDelete.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let buttonShare = UIButton(type: .system)
        buttonShare.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        buttonShare.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        buttonShare.translatesAutoresizingMaskIntoConstraints = false
        buttonShare.widthAnchor.constraint(equalToConstant: 44).isActive = true
        buttonShare.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(buttonDelete)
        stackView.addArrangedSubview(buttonShare)
        stackView.spacing = 40
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: batikView.bottomAnchor, constant: 32).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDelete() {
        
        let alert = UIAlertController(title: NSLocalizedString("Delete Batik", comment: ""), message: NSLocalizedString("Are you sure want to delete this Batik?", comment: ""), preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let delete = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { (_) in
            CoreDataServices.deleteData(self.batik!.idBatik)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true)
    }
    
    @objc private func handleShare() {
        
        if let batik = batik {
            guard let data = UIImage(data: batik.imageBatik) else { return }
            
            let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            present(activityController, animated: true)
        }
    }
    
}
