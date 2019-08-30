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
    
    func getFeeds() -> [GASongModel] {
        if let songData = playlistModel?.playlistSongs {
            return songData
        }
        return [GASongModel]()
    }
    
    func removeSongAtIndex(index :Int) {
        if var songData = playlistModel?.playlistSongs, songData.count > index {
            modelState = .updated
            songData.remove(at: index)
            playlistModel?.playlistSongs = songData
        }
    }
}


