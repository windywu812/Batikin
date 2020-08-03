//
//  HeaderCell.swift
//  Batikin
//
//  Created by Windy on 03/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit

class MyHeaderCell: UICollectionReusableView {
    
    weak var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.font = UIFont.boldSystemFont(ofSize: 22)
        addSubview(title)
        self.title = title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
