//
//  GAPlaylistDetailVM.swift
//  Gaana
//
//  Created by Pawan Agarwal on 26/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

final class GAPlaylistDetailVM: NSObject {

    var playlistModel : GAPlaylistModel?
    var modelState : GAPlaylistUpdatedState = .none
    
    init(playlistModel : GAPlaylistModel) {
        self.playlistModel = playlistModel
        super.init()
    }
    
    func getFeeds() -> [GAFeedModel] {
        if let feedData = playlistModel?.playlistSongs {
            return feedData
        }
        return [GAFeedModel]()
    }
    
    func removeSongAtIndex(index :Int) {
        if var feedData = playlistModel?.playlistSongs, feedData.count > index {
            modelState = .updated
            feedData.remove(at: index)
            playlistModel?.playlistSongs = feedData
        }
    }
}


