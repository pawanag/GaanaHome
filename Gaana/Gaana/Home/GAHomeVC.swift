//
//  GAHomeVC.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

final class GAHomeVC: UIViewController {

    private let viewModel = GAHomeVM()
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateData()
    }
    
    private func populateData() {
        registerCompletionHandler()
        viewModel.fetchHomeData()
    }
    
    // Registering Completion handler to redraw table after API call have finished
    private func registerCompletionHandler() {
        viewModel.completionHandler = { [weak self] (action) in
            DispatchQueue.main.async {
                switch action {
                case .reloadData:
                    self?.tableView.reloadData()
                default:
                    break
                }
            }
        }
    }

}

extension GAHomeVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.modelData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let modelType = viewModel.modelData[indexPath.row].viewType
        return modelType.cumulativeCellHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GACellConstants.FeedTableViewCell) as? GAFeedTableViewCell {
            if viewModel.modelData.count > indexPath.row{
                cell.configure(model: viewModel.modelData[indexPath.row] )
                cell.delegate = self
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension GAHomeVC : GAHomeListingAction {
    func seeAllTapped(songData: [GASongModel]) {
        if let detailVC = UIStoryboard(name: GAConstants.GAStoryBoardConstants.StoryboardIdentifier, bundle: nil).instantiateViewController(withIdentifier: GAControllerConstants.SongsListingVC) as? GASongsListingVC {
            detailVC.viewModel = GASongsListingVM(songData: songData)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
}
