//
//  GAFeedCollectionViewCell.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class GAFeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    func configure(model: GAFeedModel, indexPath: IndexPath, cellHeight: CGFloat){
        cellLabel.text = model.name
        cellImageView.image = nil
        if let url = URL(string: model.imageUrl ){
            GACacheImageWrapper.sharedInstance.obtainImageWithPath(url: url, indexPath: indexPath) { [weak self](image, url, indexPathObj, error) in
                if let imageObj = image, indexPath == indexPathObj{
                    self?.cellImageView.image = imageObj
                }
            }
//            heightConstraint.constant = cellHeight
        }
        
    }

}