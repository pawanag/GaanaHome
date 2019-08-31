//
//  GASongsListingVM.swift
//  Gaana
//
//  Created by Pawan Agarwal on 30/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

final class GASongsListingVM: NSObject {
    
    private var songData : [GASongModel]?
    
    init(songData : [GASongModel]) {
        self.songData = songData
        super.init()
    }
    
    func getFeeds() -> [GASongModel] {
        if let songData = songData {
            return songData
        }
        return [GASongModel]()
    }
}
