//
//  GAAddToPlaylistTableViewCell.swift
//  Gaana
//
//  Created by Pawan Agarwal on 31/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

protocol GAAddToPlaylistCellAction : class {
    func playlistSelected(state : Bool, index : Int)
}

class GAAddToPlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    var selectedState: Bool = false
    var indexPath : IndexPath?
    @IBOutlet weak var selectionButton: UIButton!
    
    weak var delegate : GAAddToPlaylistCellAction?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(playlist : GAPlaylistModel, indexPath : IndexPath, type:ListingCellType) {
        self.name.text = playlist.name
        self.indexPath = indexPath
        if type == .none {
            self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            self.selectionButton.isHidden = true
        } else {
            selectionButton.setImage(UIImage(named: type.imageName), for: .normal)
            self.selectionButton.isHidden = false
            self.accessoryType = UITableViewCell.AccessoryType.none
        }
        if let songsArray = playlist.songs?.allObjects as? [GASongModel], !songsArray.isEmpty {
            guard let imageUrl = songsArray.first?.imageUrl else {
                self.playlistImageView.image = nil
                return
            }
            GACacheImageWrapper.sharedInstance.downloadImageWith(url: URL(string: imageUrl), indexPath: indexPath, completionHandler: {[weak self] (image, url, indexPathObj, error) in
                if let image = image, indexPath == indexPathObj {
                    self?.playlistImageView.image = image
                }
            })
            
        } else {
            self.playlistImageView.image = nil
        }
    }
    
    @IBAction func selectionButtonTapped(_ sender: UIButton) {
        if let index = indexPath?.row {
            if selectedState {
                selectionButton.setImage(UIImage(named: GAImageNameConstants.CheckBoxUnSelected), for: .normal)
                selectedState = false
            } else {
                selectionButton.setImage(UIImage(named: GAImageNameConstants.CheckBoxSelected), for: .normal)
                selectedState = true
            }
            self.delegate?.playlistSelected(state: selectedState, index: index)
        }
    }
    
}
