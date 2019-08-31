//
//  GAHeaderTableViewCell.swift
//  Gaana
//
//  Created by Pawan Agarwal on 30/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class GAHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerImageView: UIImageView!
    
    override func prepareForReuse() {
        headerImageView.image = nil
        super.prepareForReuse()
    }
    
// MARK: - Configuration of HeaderView
    func configure(urlString : String, indexPath : IndexPath) {
        GACacheImageWrapper.sharedInstance.downloadImageWith(url: URL(string: urlString), indexPath: indexPath, completionHandler: {[weak self] (image, url, indexPathObj, error) in
            if let image = image, indexPath == indexPathObj {
                self?.headerImageView.image = image
            }
        })
    }
    
}
