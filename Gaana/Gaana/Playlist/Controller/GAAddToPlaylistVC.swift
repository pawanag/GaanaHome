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
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var createNewPlaylistButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addBorders()
        self.doneButtonState(enabled: false)
    }
    
    private func configureTableView() {
        registerCells()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func doneButtonState(enabled: Bool) {
        if enabled {
            doneButton.backgroundColor = UIColor.red
            doneButton.isUserInteractionEnabled = true
        } else {
            doneButton.backgroundColor = UIColor.lightGray
            doneButton.isUserInteractionEnabled = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = viewModel?.getPlaylists()
    }
    
    private func addBorders() {
        createNewPlaylistButton.layer.borderColor = UIColor.red.cgColor
        createNewPlaylistButton.layer.borderWidth = 1
        createNewPlaylistButton.layer.cornerRadius = 20
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: GACellConstants.AddToPlaylistTableViewCell, bundle: nil), forCellReuseIdentifier: GACellConstants.AddToPlaylistTableViewCell)
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createPlayListTapped(_ sender: UIButton) {
        openAlert()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.processResult(error: self.viewModel?.addSongsToSelectedPlaylists())
    }

    func openAlert(){
        let alertController = UIAlertController(title: GAAlertConstants.NewPlaylistName, message: GAAlertConstants.EnterPlaylisName, preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = GAAlertConstants.PlaylistNamePlaceholder
        }
        
        let saveAction = UIAlertAction(title:GAAlertConstants.Save, style: .default, handler: {[weak self] alert -> Void in
            if let textField = alertController.textFields?[0], let text = textField.text {
                if text.count > 0 {
                    self?.processResult(error: self?.viewModel?.addSongToNewPlaylist(name: text))
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: GAAlertConstants.Cancel, style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }

    func processResult(error: Error?) {
        if let error = error {
            let alertController = UIAlertController(title: GAAlertConstants.Error, message: error.localizedDescription, preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: GAAlertConstants.Cancel, style: .default, handler: {
                (action : UIAlertAction!) -> Void in})

            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: GAAlertConstants.Success, message: GAAlertConstants.SongAdded, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: GAAlertConstants.Ok, style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - TableView Data Source Delegates

extension GAAddToPlaylistVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getPlaylists().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: GACellConstants.AddToPlaylistTableViewCell) as? GAAddToPlaylistTableViewCell {
            if viewModel?.getPlaylists().count ?? 0 > indexPath.row {
                if let playListModel =  viewModel?.getPlaylists()[indexPath.row] {
                    cell.configure(playlist: playListModel, indexPath: indexPath, type : .addToPlaylistListing)
                    cell.delegate = self
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension GAAddToPlaylistVC : GAAddToPlaylistCellAction {
    
    func playlistSelected(state : Bool, index : Int) {

        if state {
            viewModel?.selectedIndexes[index] = state
        } else {
            viewModel?.selectedIndexes.removeValue(forKey: index)
        }
        doneButtonState(enabled: viewModel?.selectedIndexes.count ?? 0 > 0)
    }
    
}
