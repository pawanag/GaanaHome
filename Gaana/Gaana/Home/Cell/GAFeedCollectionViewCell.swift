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
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    func configure(model: GASongModel, indexPath: IndexPath, cellType: GAViewType){
        //config cell components
        cellImageView.layer.cornerRadius = cellType.cellImageCornerRadius
        cellHeight.constant = cellType.cellSize.height
        cellWidth.constant = cellType.cellSize.width
        cellLabel.text = model.name
        cellLabel.font = cellType.font
        cellImageView.image = nil
        
        if let url = URL(string: model.imageUrl ?? "" ){
            GACacheImageWrapper.sharedInstance.downloadImageWith(url: url, indexPath: indexPath) { [weak self](image, url, indexPathObj, error) in
                if let imageObj = image, indexPath == indexPathObj{
                    self?.cellImageView.image = imageObj
                }
            }
        }
    }

}
