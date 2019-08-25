//
//  GAFeedTableViewCell.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class GAFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerText: UILabel!
    private var feedModels = [GAFeedModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(model : GAHomeMainModel) {
        self.headerText.text = model.name
        self.feedModels = model.tracks
//        let flowLayout = UICollectionViewFlowLayout()
//       
//            flowLayout.scrollDirection = .horizontal
//            collectionView.collectionViewLayout = flowLayout
        
        collectionView.reloadData()
    }
}

extension GAFeedTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GAFeedCollectionViewCell", for: indexPath) as? GAFeedCollectionViewCell {
            if feedModels.count > indexPath.row {
                cell.configure(model: feedModels[indexPath.row], indexPath: indexPath, cellHeight: 200)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row < feedModels.count{
            let url = feedModels[indexPath.row].imageUrl
            GACacheImageWrapper.sharedInstance.slowDownImageDownLoadTask(url: URL(string: url))
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 155, height: 155 + 30)
    }
    
}
