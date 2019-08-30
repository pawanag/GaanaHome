//
//  GAAddToPlaylistVM.swift
//  Gaana
//
//  Created by Pawan Agarwal on 30/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

final class GAAddToPlaylistVM {

    var playlistData = [GAPlaylistModel]()
    var modelToBeSaved : GASongModel
    
    init(modelToBeSaved : GASongModel) {
        self.modelToBeSaved = modelToBeSaved
    }
    
    func addSongToNewPlaylist(name : String) {
        GACoreDataManager.sharedInstance.addSongToNewPlaylist(name: name, songModel: modelToBeSaved)
        playlistData = GACoreDataManager.sharedInstance.getAllPlaylists()
    }

    func addSongToPlaylists(playlists:[GAPlaylistModel]) {
        
    }
    func getPlaylists() -> [GAPlaylistModel] {
        if playlistData.count == 0 {
            playlistData = GACoreDataManager.sharedInstance.getAllPlaylists()
            return playlistData
        } else {
            return playlistData
        }
    }
        
    private func persistPlaylist() {
        
        
    }
    
}
