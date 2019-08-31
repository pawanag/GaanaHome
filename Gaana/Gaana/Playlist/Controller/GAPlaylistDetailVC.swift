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
        configureTableView()
        addBarButton()
    }
    
    private func configureTableView() {
        registerCells()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    private func addBarButton() {
        let add = UIBarButtonItem(image: UIImage(named: GAImageNameConstants.Delete), style: .plain, target: self, action: #selector(deleteTapped))
        self.navigationItem.rightBarButtonItem = add
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: GACellConstants.HeaderViewCell, bundle: nil), forCellReuseIdentifier: GACellConstants.HeaderViewCell)
        self.tableView.register(UINib(nibName: GACellConstants.ListingTableViewCell, bundle: nil), forCellReuseIdentifier: GACellConstants.ListingTableViewCell)
    }
    
    @objc func deleteTapped() {
        let alertController = UIAlertController(title: viewModel?.playlistModel?.name ?? "", message: GAAlertConstants.SureDeletePlaylist, preferredStyle: .alert)
        let okAction = UIAlertAction(title: GAAlertConstants.Ok, style: .default, handler: {[weak self] alert -> Void in
            self?.viewModel?.modelState = .deleted
            self?.navigationController?.popViewController(animated: true)
            // Delete Playlist
        })
        let cancelAction = UIAlertAction(title: GAAlertConstants.Cancel, style: .default, handler: {
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
            if let headerCell = tableView.dequeueReusableCell(withIdentifier: GACellConstants.HeaderViewCell) as? GAHeaderTableViewCell {
                let model = viewModel?.getFeeds().first
                headerCell.configure(urlString: model?.imageUrl ?? "", indexPath: indexPath)
                return headerCell
            }
        case .listing:
            if let cell = tableView.dequeueReusableCell(withIdentifier: GACellConstants.ListingTableViewCell) as? GAListingTableViewCell {
                if viewModel?.getFeeds().count ?? 0 > indexPath.row, let songModel =  viewModel?.getFeeds()[indexPath.row] {
                    cell.configure(song: songModel, indexPath: indexPath, type : .playlistDetailListing)
                    cell.delegate = self
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
            
//            tableView.deleteRows(at: [indexPath], with: .fade)
            if let songsArray = viewModel?.playlistModel?.songs?.allObjects as? [GASongModel], songsArray.count == 1, indexPath.row == 0 {
                viewModel?.removeSongAtIndex(index:indexPath.row)
                self.navigationController?.popViewController(animated: true)
            } else {
                viewModel?.removeSongAtIndex(index:indexPath.row)
                tableView.reloadData()
            }
        }
    }
    
}
extension GAPlaylistDetailVC : GAListingCellAction {
    func listingSelectedForType(type : ListingCellType, modelData : GASongModel) {
        if type == ListingCellType.playlistDetailListing {
            if let addToPlaylistVC = UIStoryboard(name: GAConstants.GAStoryBoardConstants.StoryboardIdentifier, bundle: nil).instantiateViewController(withIdentifier: GAControllerConstants.AddToPlaylist) as? GAAddToPlaylistVC {
                let addToPlaylistVM = GAAddToPlaylistVM(modelToBeSaved: modelData)
                addToPlaylistVC.viewModel = addToPlaylistVM
                self.present(addToPlaylistVC, animated: true, completion: nil)
            }
        }
    }
    
}
