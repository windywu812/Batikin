//
//  OnboardingViewController.swift
//  Batikin
//
//  Created by Muhammad Rasyid khaikal on 13/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        title.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        title.text = "Welcome to Batikin!"
        title.textAlignment = .center
        
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -180).isActive = true
        
        let img1 = UIImageView()
        img1.image = UIImage(systemName: "pencil.slash")
        img1.contentMode = .scaleAspectFit
        img1.translatesAutoresizingMaskIntoConstraints = false
        img1.widthAnchor.constraint(equalToConstant: 50).isActive = true
        img1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let boldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        let regularAttribute = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)
        ]
        
        let label1 = UILabel()
        let boldText1 = NSAttributedString(string: "More Personalized\n", attributes: boldAttribute)
        let regularText1 = NSAttributedString(string: "Combine Batik Elements", attributes: regularAttribute)
        let newString1 = NSMutableAttributedString()
        newString1.append(boldText1)
        newString1.append(regularText1)
        
        label1.attributedText = newString1
        label1.sizeToFit()
        label1.numberOfLines = 0
        label1.lineBreakMode = .byWordWrapping
        label1.textAlignment = .left
        
        let stack1 = UIStackView()
        stack1.addArrangedSubview(img1)
        stack1.addArrangedSubview(label1)
        stack1.axis = .horizontal
        stack1.spacing = 16
        stack1.alignment = .fill
        view.addSubview(stack1)
        
        stack1.translatesAutoresizingMaskIntoConstraints = false
        stack1.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 70).isActive = true
        stack1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack1.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -80).isActive = true

        let img2 = UIImageView()
        img2.image = UIImage(systemName: "square.and.pencil")
        img2.contentMode = .scaleAspectFit
        img2.translatesAutoresizingMaskIntoConstraints = false
        img2.widthAnchor.constraint(equalToConstant: 50).isActive = true
        img2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let label2 = UILabel()
        let boldText2 = NSAttributedString(string: "Your own Motif\n", attributes: boldAttribute)
        let regularText2 = NSAttributedString(string: "Create new motif of Batik Batam", attributes: regularAttribute)
        let newString2 = NSMutableAttributedString()
        newString2.append(boldText2)
        newString2.append(regularText2)
        
        label2.attributedText = newString2
        label2.numberOfLines = 0
        label2.adjustsFontSizeToFitWidth = true
        label2.textAlignment = .left
        
        let stack2 = UIStackView()
        stack2.addArrangedSubview(img2)
        stack2.addArrangedSubview(label2)
        stack2.axis = .horizontal
        stack2.spacing = 16
        stack2.alignment = .fill
        view.addSubview(stack2)
        
        stack2.translatesAutoresizingMaskIntoConstraints = false
        stack2.topAnchor.constraint(equalTo: img1.bottomAnchor,constant: 30).isActive = true
        stack2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack2.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -80).isActive = true
        
        let img3 = UIImageView()
        img3.image = UIImage(systemName: "person.3.fill")
        img3.contentMode = .scaleAspectFit
        img3.translatesAutoresizingMaskIntoConstraints = false
        img3.widthAnchor.constraint(equalToConstant: 50).isActive = true
        img3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let label3 = UILabel()
        let boldText3 = NSAttributedString(string: "Share your Batik\n", attributes: boldAttribute)
        let regularText3 = NSAttributedString(string: "Make Batik Batam well known", attributes: regularAttribute)
        let newString3 = NSMutableAttributedString()
        newString3.append(boldText3)
        newString3.append(regularText3)
        
        label3.attributedText = newString3
        label3.adjustsFontSizeToFitWidth = true
        label3.numberOfLines = 0
        label3.textAlignment = .left
        label3.translatesAutoresizingMaskIntoConstraints = false
        
        let stack3 = UIStackView()
        stack3.addArrangedSubview(img3)
        stack3.addArrangedSubview(label3)
        stack3.axis = .horizontal
        stack3.spacing = 16
        stack3.alignment = .fill
        view.addSubview(stack3)
        
        stack3.translatesAutoresizingMaskIntoConstraints = false
        stack3.topAnchor.constraint(equalTo: img2.bottomAnchor,constant: 30).isActive = true
        stack3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack3.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -80).isActive = true

        let getStartedBtn = UIButton(type: .system)
        getStartedBtn.backgroundColor = UIColor(named: CustomColor.tintColor.color)
        getStartedBtn.setTitle("Get Started", for: .normal)
        getStartedBtn.setTitleColor(UIColor(named: CustomColor.canvasBackground.color), for: .normal)
        getStartedBtn.layer.cornerRadius = 8
        view.addSubview(getStartedBtn)
        
        getStartedBtn.translatesAutoresizingMaskIntoConstraints = false
        getStartedBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getStartedBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48).isActive = true
        getStartedBtn.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -80).isActive = true
        getStartedBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        getStartedBtn.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapButton(_ button:UIButton) {
        UserDefault.hasLaunched = true
        dismiss(animated: true, completion: nil)
        print(UserDefault.hasLaunched)
    }
    
}
