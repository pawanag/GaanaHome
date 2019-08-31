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
    var selectedIndexes = [Int:Bool]()
    
    init(modelToBeSaved : GASongModel) {
        self.modelToBeSaved = modelToBeSaved
    }
    
    func createPlaylist(name : String) -> Error?  {
        _ = GACoreDataManager.sharedInstance.getPlaylist(withName: name)
        return GACoreDataManager.sharedInstance.saveContext()
    }
    
    // Add Song to Newly created Playlist
    // This method is not required as the Songs could be added only on the pressof Done Button
//    func addSongToNewPlaylist(name : String) -> Error? {
//        var error = GACoreDataManager.sharedInstance.addSongToNewPlaylist(name: name, songModel: modelToBeSaved)
//        if error == nil {
//            error = addSongsToSelectedPlaylists()
//            playlistData = GACoreDataManager.sharedInstance.getAllPlaylists()
//        }
//        return error
//    }

    // Add Songs to All the selected Playlists
    func addSongsToSelectedPlaylists() -> Error? {
        if selectedIndexes.count > 0 {
            var playLists = [GAPlaylistModel]()
            for index in selectedIndexes.keys {
                let playlist = playlistData[index]
                playLists.append(playlist)
            }
            return GACoreDataManager.sharedInstance.addSongToPlaylists(playlists: playLists, songModel: modelToBeSaved)
        }
        return nil
    }

    func getPlaylists() {
        playlistData = GACoreDataManager.sharedInstance.getAllPlaylists(songId: modelToBeSaved.itemId)
    }
    
}
