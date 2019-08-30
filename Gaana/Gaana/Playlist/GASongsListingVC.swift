//
//  GASongsListingVC.swift
//  Gaana
//
//  Created by Pawan Agarwal on 30/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

final class GASongsListingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel : GASongsListingVM?
    private var playlistSections : [PlaylistDetailSection] = [.header,.listing]

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: "GAHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "GAHeaderTableViewCell")
        self.tableView.register(UINib(nibName: "GAListingTableViewCell", bundle: nil), forCellReuseIdentifier: "GAListingTableViewCell")
    }

}

// MARK: - TableView Data Source Delegates

extension GASongsListingVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return playlistSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let playlistSection = playlistSections[section]
        switch playlistSection {
        case .header:
            return 1
        case .listing:
            return viewModel?.getFeeds().count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let playlistSection = playlistSections[indexPath.section]
        switch playlistSection {
        case .header:
            return 240
        default:
            return 85
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlistSection = playlistSections[indexPath.section]
        switch playlistSection {
        case .header:
            if let headerCell = tableView.dequeueReusableCell(withIdentifier: "GAHeaderTableViewCell") as? GAHeaderTableViewCell {
                let model = viewModel?.getFeeds().first
                headerCell.configure(urlString: model?.imageUrl ?? "", indexPath: indexPath)
                return headerCell
            }
        case .listing:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GAListingTableViewCell") as? GAListingTableViewCell {
                if viewModel?.getFeeds().count ?? 0 > indexPath.row, let songModel =  viewModel?.getFeeds()[indexPath.row] {
                    cell.configure(song: songModel, indexPath: indexPath, type : .songsListing)
                    cell.delegate = self
                }
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension GASongsListingVC : GAListingCellAction {
    func listingSelectedForType(type : ListingCellType, modelData : Any) {
        if let songModel = modelData as? GASongModel, type == ListingCellType.songsListing {
            if let addToPlaylistVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GAAddToPlaylistVC") as? GAAddToPlaylistVC {
                let addToPlaylistVM = GAAddToPlaylistVM(modelToBeSaved: songModel)
                addToPlaylistVC.viewModel = addToPlaylistVM
                self.present(addToPlaylistVC, animated: true, completion: nil)
            }
        }
    }
    
}
