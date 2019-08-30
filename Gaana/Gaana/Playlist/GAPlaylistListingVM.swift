//
//  GAPlaylistListingVM.swift
//  Gaana
//
//  Created by Pawan Agarwal on 26/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class GAPlaylistListingVM: NSObject {

    var playlistData = [GAPlaylistModel]()
    
    func dummyData() {
        let playlist = GAPlaylistModel()
        playlist.playlistName = "test1"
        let feedModel = GAFeedModel(imageUrl: "http://a10.gaanacdn.com/images/albums/72/2657072/crop_480x480_2657072.jpg", name: "SeÃ±orita", itemId: "27290114")
        playlist.playlistSongs.append(feedModel)
        playlist.playlistSongs.append(feedModel)
        playlistData.append(playlist)
    }
    func getPlaylists() -> [GAPlaylistModel] {
        dummyData()
        return playlistData
    }
    
    func createPlaylist(name : String, song : GAFeedModel) {
        let playlistObj = GAPlaylistModel()
        playlistObj.playlistName = name
        playlistObj.playlistSongs.append(song)
        self.playlistData.append(playlistObj)
        persistPlaylist()
    }
    
    private func persistPlaylist() {
        
        
    }
}
