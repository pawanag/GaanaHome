//
//  GAPlaylistTableViewCell.swift
//  Gaana
//
//  Created by Pawan Agarwal on 26/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class GAPlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistName: UILabel!

    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(playlist : GAPlaylistModel, indexPath : IndexPath) {
        self.playlistName.text = playlist.playlistName
        guard let imageUrl = playlist.playlistSongs.first?.imageUrl else {
            return
        }
        GACacheImageWrapper.sharedInstance.downloadImageWith(url: URL(string: imageUrl), indexPath: indexPath, completionHandler: {[weak self] (image, url, indexPathObj, error) in
            if let image = image, indexPath == indexPathObj {
                self?.playlistImageView.image = image
            }
        })
    }
}
