//
//  GAPlaylistViewController.swift
//  Gaana
//
//  Created by Pawan Agarwal on 26/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit


class GAPlaylistListingVC: UIViewController {

    private let viewModel = GAPlaylistListingVM()
    @IBOutlet weak var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = add
       // navigationItem.rightBarButtonItems = [add]
        
        // Do any additional setup after loading the view.
    }
    
    @objc func addTapped() {
        
    }
    private func registerCells() {
        self.tableView.register(UINib(nibName: "GAListingTableViewCell", bundle: nil), forCellReuseIdentifier: "GAListingTableViewCell")
    }

}

extension GAPlaylistListingVC :UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getPlaylists().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GAListingTableViewCell") as? GAListingTableViewCell {
//            let playlists = viewModel.getPlaylists()
            if viewModel.getPlaylists().count > indexPath.row {
            cell.configure(playlist: viewModel.getPlaylists()[indexPath.row], indexPath: indexPath,type : ListingCellType.none)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.getPlaylists().count > indexPath.row {
            if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GAPlaylistDetailVC") as? GAPlaylistDetailVC {
                detailVC.viewModel = GAPlaylistDetailVM(feedData: viewModel.getPlaylists()[indexPath.row].playlistSongs)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }

        }
    }
}
