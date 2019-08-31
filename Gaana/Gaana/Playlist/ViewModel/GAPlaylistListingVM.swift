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
    }

    func getPlaylists() {
        playlistData = GACoreDataManager.sharedInstance.getAllPlaylists()
    }
    
    func createPlaylist(name : String) -> Error?  {
        _ = GACoreDataManager.sharedInstance.getPlaylist(withName: name)
        return GACoreDataManager.sharedInstance.saveContext()
    }
    
    func updatePlaylist(playlistModel:GAPlaylistModel, state : GAPlaylistUpdatedState) {
        switch state {
        case .deleted:
            for (index,model) in playlistData.enumerated() {
                if model.name == playlistModel.name {
                    playlistData.remove(at: index)
                    GACoreDataManager.sharedInstance.removePlaylist(name: model.name ?? "")
                }
            }
        case .updated:
            for (index,model) in playlistData.enumerated() {
                if model.name == playlistModel.name {
                    playlistData[index] = model
                }
            }
        case .none:
            break

        }
    }
}
