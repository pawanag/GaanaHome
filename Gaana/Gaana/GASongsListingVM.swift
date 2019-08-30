//
//  GASongsListingVM.swift
//  Gaana
//
//  Created by Pawan Agarwal on 30/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class GASongsListingVM: NSObject {
    
    private var feedData : [GAFeedModel]?
    
    init(feedData : [GAFeedModel]) {
        self.feedData = feedData
        super.init()
    }
    
    func getFeeds() -> [GAFeedModel] {
        if let feedData = feedData {
            return feedData
        }
        return [GAFeedModel]()
    }
}
