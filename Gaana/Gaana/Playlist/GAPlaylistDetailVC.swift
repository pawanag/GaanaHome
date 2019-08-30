//
//  GAPlaylistDetailVC.swift
//  Gaana
//
//  Created by Pawan Agarwal on 26/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

enum GAPlaylistUpdatedState {
    case deleted
    case updated
    case none
}

protocol GADetailListingProtocol : class {
    func updateModel(playlistModel:GAPlaylistModel, state : GAPlaylistUpdatedState)
}

enum PlaylistDetailSection : Int {
    case header
    case listing
}

final class GAPlaylistDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var playlistSections : [PlaylistDetailSection] = [.header,.listing]
    var viewModel : GAPlaylistDetailVM?
    weak var delegate : GADetailListingProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = false
        let add = UIBarButtonItem(image: UIImage(named: "delete"), style: .plain, target: self, action: #selector(deleteTapped))
        self.navigationItem.rightBarButtonItem = add
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: "GAHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "GAHeaderTableViewCell")
        self.tableView.register(UINib(nibName: "GAListingTableViewCell", bundle: nil), forCellReuseIdentifier: "GAListingTableViewCell")
    }
    
    @objc func deleteTapped() {
        
        let alertController = UIAlertController(title: viewModel?.playlistModel?.playlistName ?? "", message: "Do you want to delete this playlist?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {[weak self] alert -> Void in
            self?.viewModel?.modelState = .deleted
            self?.navigationController?.popViewController(animated: true)
            // Delete Playlist
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.preferredAction = okAction
        
        self.present(alertController, animated: true, completion: nil)
        // Sure to delete Playlist
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let playlistModel = viewModel?.playlistModel, let state =  viewModel?.modelState{
            self.delegate?.updateModel(playlistModel: playlistModel, state: state)
        }
        super.viewWillDisappear(animated)
    }

}

// MARK: - TableView Data Source Delegates

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
                if viewModel?.getFeeds().count ?? 0 > indexPath.row, let songModel =  viewModel?.getFeeds()[indexPath.row] {
                    cell.configure(song: songModel, indexPath: indexPath, type : .playlistListing)
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let playlistSection = playlistSections[indexPath.section]
        switch playlistSection {
        case .header:
            return false
        default:
                return true
        }
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.removeSongAtIndex(index:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}
