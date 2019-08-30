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

//        GACoreDataManager.sharedInstance.getAllPlaylists()
        dummyData()
    }
    func dummyData() {
        var playlist = GAPlaylistModel()
        playlist.playlistName = "test1"
        let songModel1 = GASongModel(imageUrl: "http://a10.gaanacdn.com/images/albums/72/2657072/crop_480x480_2657072.jpg", name: "SeÃ±orita", itemId: "27290114")
        
        let songModel4 = GASongModel(imageUrl: "http://a10.gaanacdn.com/images/albums/69/2437469/crop_480x480_2437469.jpg", name: "On My Way", itemId: "25658817")

        playlist.playlistSongs.append(songModel1)
        playlist.playlistSongs.append(songModel4)
        
        var playlist1 = GAPlaylistModel()
        playlist1.playlistName = "test2"
        let songModel2 = GASongModel(imageUrl: "http://a10.gaanacdn.com/images/albums/72/2657072/crop_480x480_2657072.jpg", name: "SeÃ±orita", itemId: "27290114")
        let songModel3 = GASongModel(imageUrl: "http://a10.gaanacdn.com/images/albums/69/2437469/crop_480x480_2437469.jpg", name: "On My Way", itemId: "25658817")
        playlist1.playlistSongs.append(songModel2)
        playlist1.playlistSongs.append(songModel3)
        
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
    
    func createPlaylist(name : String, song : GASongModel) {
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
