//
//  GAAddToPlaylistVC.swift
//  Gaana
//
//  Created by Pawan Agarwal on 30/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

final class GAAddToPlaylistVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel : GAAddToPlaylistVM?
    
    @IBOutlet weak var createNewPlaylistButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        addBorders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.getPlaylists()
    }
    
    private func addBorders() {
        createNewPlaylistButton.layer.borderColor = UIColor.red.cgColor
        createNewPlaylistButton.layer.borderWidth = 1
        createNewPlaylistButton.layer.cornerRadius = 20
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: "GAListingTableViewCell", bundle: nil), forCellReuseIdentifier: "GAListingTableViewCell")
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createPlayListTapped(_ sender: UIButton) {
        openAlert()
    }
    
    func openAlert(){
        let alertController = UIAlertController(title: "New Playlist Name", message: "Enter a playlist name", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Playlist name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {[weak self] alert -> Void in
            if let textField = alertController.textFields?[0], let text = textField.text {
                if text.count > 0 {
                    self?.viewModel?.addSongToNewPlaylist(name: text)
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
}

// MARK: - TableView Data Source Delegates

extension GAAddToPlaylistVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getPlaylists().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GAListingTableViewCell") as? GAListingTableViewCell {
            if viewModel?.getPlaylists().count ?? 0 > indexPath.row {
                if let playListModel =  viewModel?.getPlaylists()[indexPath.row] {
                    cell.configure(playlist: playListModel, indexPath: indexPath, type : .addToPlaylistListing)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}
