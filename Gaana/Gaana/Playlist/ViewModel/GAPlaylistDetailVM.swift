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
    
    init(playlistModel : GAPlaylistModel) {
        self.playlistModel = playlistModel
        super.init()
    }
    
    func getFeeds() -> [GASongModel] {
        if let songData = playlistModel?.songs?.allObjects as? [GASongModel], !songData.isEmpty {
            return songData
        }
        return [GASongModel]()
    }
    
    func deletePlaylist() {
        if let name = playlistModel?.name {
            GACoreDataManager.sharedInstance.removePlaylist(name: name)
        }
    }
    
    func removeSongAtIndex(index :Int) {
        if var songData = playlistModel?.songs?.allObjects as? [GASongModel], songData.count > index {
            let song = songData.remove(at: index)
            GACoreDataManager.sharedInstance.updatePlaylist(name: playlistModel?.name ?? "", songModel: song)
        }
    }
}


