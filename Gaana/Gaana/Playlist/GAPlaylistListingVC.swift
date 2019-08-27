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
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }

}

extension GAPlaylistListingVC :UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getPlaylists().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GAPlaylistTableViewCell") as? GAPlaylistTableViewCell {
//            let playlists = viewModel.getPlaylists()
            if viewModel.getPlaylists().count > indexPath.row {
            cell.configure(playlist: viewModel.getPlaylists()[indexPath.row], indexPath: indexPath)
            }
            return cell
        }
        return UITableViewCell()
    }
}
