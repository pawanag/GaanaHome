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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(urlString : String, indexPath : IndexPath) {
        GACacheImageWrapper.sharedInstance.downloadImageWith(url: URL(string: urlString), indexPath: indexPath, completionHandler: {[weak self] (image, url, indexPathObj, error) in
            if let image = image, indexPath == indexPathObj {
                self?.headerImageView.image = image
            }
        })
    }
    
}
