//
//  GAListingTableViewCell.swift
//  Gaana
//
//  Created by Pawan Agarwal on 30/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit
import Foundation

protocol GAListingCellAction : class {
    func listingSelectedForType(type : ListingCellType, modelData : GASongModel)
}

enum ListingCellType {
    case songsListing
    case addToPlaylistListing
    case playlistDetailListing
    case none
    
    var imageName: String{
        switch self {
        case .songsListing,.playlistDetailListing:
            return GAImageNameConstants.AddToPlaylist
        case .addToPlaylistListing:
            return GAImageNameConstants.CheckBoxUnSelected
        default:
            return ""
        }
    }
    
}

class GAListingTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var listingCellType : ListingCellType = .none
    weak var delegate : GAListingCellAction?
    private var model : GASongModel?

    override func prepareForReuse() {
        resetCell()
        super.prepareForReuse()
    }
    
    private func resetCell() {
        playlistImageView.image = nil
        name.text = ""
    }
    
    func configure(song : GASongModel, indexPath : IndexPath, type:ListingCellType) {
        self.name.text = song.name
        let imageUrl = song.imageUrl
        selectionButton.setImage(UIImage(named: type.imageName), for: .normal)
        self.listingCellType = type
        self.model = song
        GACacheImageWrapper.sharedInstance.downloadImageWith(url: URL(string: imageUrl ?? ""), indexPath: indexPath, completionHandler: {[weak self] (image, url, indexPathObj, error) in
            if let image = image, indexPath == indexPathObj {
                self?.playlistImageView.image = image
            }
        })
    }

    @IBAction func selectionButtonTapped(_ sender: UIButton) {
        self.delegate?.listingSelectedForType(type: listingCellType, modelData : model!)
    }
}
