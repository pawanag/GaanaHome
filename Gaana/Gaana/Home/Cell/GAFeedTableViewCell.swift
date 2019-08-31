//
//  GAFeedTableViewCell.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

protocol GAHomeListingAction : class {
    func seeAllTapped(songData:[GASongModel])
}

class GAFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerText: UILabel!
    private var songModels = [GASongModel]()
    private var cellType : GAViewType = .unknown
    weak var delegate : GAHomeListingAction?
    
    func configure(model : GAHomeMainModel) {
        self.headerText.text = model.name
        self.songModels = model.tracks
        cellType = model.viewType
//        let flowLayout = UICollectionViewFlowLayout()
//       
//            flowLayout.scrollDirection = .horizontal
//            collectionView.collectionViewLayout = flowLayout
        
        collectionView.reloadData()
    }
    @IBAction func seeAllTapped(_ sender: UIButton) {
        self.delegate?.seeAllTapped(songData: songModels)
    }
}

extension GAFeedTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GACellConstants.FeedCollectionViewCell, for: indexPath) as? GAFeedCollectionViewCell {
            if songModels.count > indexPath.row {
                cell.configure(model: songModels[indexPath.row], indexPath: indexPath, cellType: cellType)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row < songModels.count{
            let url = songModels[indexPath.row].imageUrl
        GACacheImageWrapper.sharedInstance.slowDownImageDownLoadTask(url: URL(string: url ?? ""))
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellType.collectionCellSize
    }
    
}
