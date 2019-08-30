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
    var modelToBeSaved : GAFeedModel
    
    init(modelToBeSaved : GAFeedModel) {
        self.modelToBeSaved = modelToBeSaved
    }
    
    func addSongToNewPlaylist(name : String) {
        GACoreDataManager.sharedInstance.addSongToNewPlaylist(name: name, song: modelToBeSaved)
    }
    
//    func getAllPlaylists() -> [GAPlaylistModel]? {
//       let arrayOfPlaylist = GACoreDataManager.sharedInstance.getAllPlaylists()
//        return
//    }
    
    
    func dummyData() {
        var playlist = GAPlaylistModel()
        playlist.playlistName = "test1"
        let feedModel = GAFeedModel(imageUrl: "http://a10.gaanacdn.com/images/albums/72/2657072/crop_480x480_2657072.jpg", name: "SeÃ±orita", itemId: "27290114")
        playlist.playlistSongs.append(feedModel)
        playlist.playlistSongs.append(feedModel)
        playlistData.append(playlist)
    }
    func getPlaylists() -> [GAPlaylistModel] {
        dummyData()
        return playlistData
        if playlistData.count > 0 {
            return playlistData
        } else {
            let playlist = GACoreDataManager.sharedInstance.getAllPlaylists()
            return playlistData
        }
    }
    
//    func mapData(model : [PlaylistModel]) -> [GAPlaylistModel] {
////        let names = model.map({ (song) -> PlaylistModel in
////            return song.name
////        })
//    }
    
    func createPlaylist(name : String, song : GAFeedModel) {
        var playlistObj = GAPlaylistModel()
        playlistObj.playlistName = name
        playlistObj.playlistSongs.append(song)
        self.playlistData.append(playlistObj)
        persistPlaylist()
    }
    
    private func persistPlaylist() {
        
        
    }
    
}
