//
//  GAPlaylistListingVM.swift
//  Gaana
//
//  Created by Pawan Agarwal on 26/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

final class GAPlaylistListingVM: NSObject {

    var playlistData = [GAPlaylistModel]()
    
    override init() {
        super.init()

        GACoreDataManager.sharedInstance.getAllPlaylists()
        dummyData()
    }
    func dummyData() {
        var playlist = GAPlaylistModel()
        playlist.playlistName = "test1"
        let feedModel1 = GAFeedModel(imageUrl: "http://a10.gaanacdn.com/images/albums/72/2657072/crop_480x480_2657072.jpg", name: "SeÃ±orita", itemId: "27290114")
        
        let feedModel4 = GAFeedModel(imageUrl: "http://a10.gaanacdn.com/images/albums/69/2437469/crop_480x480_2437469.jpg", name: "On My Way", itemId: "25658817")

        playlist.playlistSongs.append(feedModel1)
        playlist.playlistSongs.append(feedModel4)
        
        var playlist1 = GAPlaylistModel()
        playlist1.playlistName = "test2"
        let feedModel2 = GAFeedModel(imageUrl: "http://a10.gaanacdn.com/images/albums/72/2657072/crop_480x480_2657072.jpg", name: "SeÃ±orita", itemId: "27290114")
        let feedModel3 = GAFeedModel(imageUrl: "http://a10.gaanacdn.com/images/albums/69/2437469/crop_480x480_2437469.jpg", name: "On My Way", itemId: "25658817")
        playlist1.playlistSongs.append(feedModel2)
        playlist1.playlistSongs.append(feedModel3)
        
        playlistData.append(playlist)
        playlistData.append(playlist1)
    }
    func getPlaylists() -> [GAPlaylistModel] {
        
        return playlistData
    }
    
    func createPlaylist(name : String)  {
        var playlist = GAPlaylistModel()
        playlist.playlistName = name
        playlistData.append(playlist)
        persistPlaylist()
    }
    
    func createPlaylist(name : String, song : GAFeedModel) {
        var playlistObj = GAPlaylistModel()
        playlistObj.playlistName = name
        playlistObj.playlistSongs.append(song)
        self.playlistData.append(playlistObj)
        persistPlaylist()
    }
    
    func updatePlaylist(playlistModel:GAPlaylistModel, state : GAPlaylistUpdatedState) {
        switch state {
        case .deleted:
            for (index,model) in playlistData.enumerated() {
                if model.playlistName == playlistModel.playlistName {
                    playlistData.remove(at: index)
                }
            }
        case .updated:
            for (index,model) in playlistData.enumerated() {
                if model.playlistName == playlistModel.playlistName {
                    playlistData[index] = model
                }
            }
        case .none:
            break

        }
    }
    private func persistPlaylist() {
        
        
    }
}
