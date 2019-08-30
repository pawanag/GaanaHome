//
//  GAPlaylistViewController.swift
//  Gaana
//
//  Created by Pawan Agarwal on 26/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit


final class GAPlaylistListingVC: UIViewController {

    private let viewModel = GAPlaylistListingVM()
    @IBOutlet weak var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        let add = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = add
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getPlaylists()
        checkIfReloadRequired()
    }
    
    private func checkIfReloadRequired() {
        if tableView.numberOfRows(inSection: 0) != viewModel.playlistData.count {
            self.tableView.reloadData()
        }
    }
    @objc private func addTapped() {
        let alertController = UIAlertController(title: "New Playlist Name", message: "Enter a playlist name", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Playlist name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {[weak self] alert -> Void in
            if let textField = alertController.textFields?[0], let text = textField.text {
                if text.count > 0 {
                    self?.viewModel.createPlaylist(name:text)
                    self?.tableView.reloadData()
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: "GAListingTableViewCell", bundle: nil), forCellReuseIdentifier: "GAListingTableViewCell")
    }

}
// MARK: - TableView Data Source Delegates

extension GAPlaylistListingVC :UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playlistData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GAListingTableViewCell") as? GAListingTableViewCell {
//            let playlists = viewModel.getPlaylists()
            if viewModel.playlistData.count > indexPath.row {
            cell.configure(playlist: viewModel.playlistData[indexPath.row], indexPath: indexPath,type : ListingCellType.none)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.playlistData.count > indexPath.row {
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GAPlaylistDetailVC") as? GAPlaylistDetailVC {
                detailVC.viewModel = GAPlaylistDetailVM(playlistModel: viewModel.playlistData[indexPath.row])
                detailVC.delegate = self
                self.navigationController?.pushViewController(detailVC, animated: true)
            }

        }
        
    }
    
}

extension GAPlaylistListingVC : GADetailListingProtocol {
    func updateModel(playlistModel:GAPlaylistModel, state : GAPlaylistUpdatedState) {
        viewModel.updatePlaylist(playlistModel: playlistModel, state: state)
        self.tableView.reloadData()
    }
}
