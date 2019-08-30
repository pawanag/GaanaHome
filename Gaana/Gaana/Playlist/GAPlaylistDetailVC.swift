//
//  GAPlaylistDetailVC.swift
//  Gaana
//
//  Created by Pawan Agarwal on 26/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

enum PlaylistDetailSection : Int {
    case header
    case listing
}

class GAPlaylistDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var playlistSections : [PlaylistDetailSection] = [.header,.listing]
    var viewModel : GAPlaylistDetailVM?
    
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

extension GAPlaylistDetailVC : UITableViewDataSource, UITableViewDelegate {
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
                if viewModel?.getFeeds().count ?? 0 > indexPath.row, let feedModel =  viewModel?.getFeeds()[indexPath.row] {
                    cell.configure(feed: feedModel, indexPath: indexPath, type : .playlistListing)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
}
