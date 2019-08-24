//
//  ViewController.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let viewModel = GAHomeViewModel()
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.populateData()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
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

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.modelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GAFeedTableViewCell") as? GAFeedTableViewCell {
            if viewModel.modelData.count > indexPath.row{
                cell.configure(model: viewModel.modelData[indexPath.row] )
            }
            return cell
        }
        return UITableViewCell()
    }
}
