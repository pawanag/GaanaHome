//
//  GAAddToPlaylistVC.swift
//  Gaana
//
//  Created by Pawan Agarwal on 30/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class GAAddToPlaylistVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel = GAAddToPlaylistVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: "GAListingTableViewCell", bundle: nil), forCellReuseIdentifier: "GAListingTableViewCell")
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension GAAddToPlaylistVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getPlaylists().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GAListingTableViewCell") as? GAListingTableViewCell {
            if viewModel.getPlaylists().count > indexPath.row {
                let playListModel =  viewModel.getPlaylists()[indexPath.row]
                cell.configure(playlist: playListModel, indexPath: indexPath, type : .addToPlaylistListing)
            }
            return cell
        }
        return UITableViewCell()
    }
}
