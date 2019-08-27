//
//  GAHomeMainModel.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class GAHomeModel : Decodable {
    var status : Int
    var sections : [GAHomeMainModel]
    enum CodingKeys: String, CodingKey {
        case status
        case sections = "sections"
    }
}

class GAHomeMainModel : Decodable {
    var name : String
    var tracks : [GAFeedModel]
    enum CodingKeys: String, CodingKey {
        case name,tracks
    }
}

class GAFeedModel : Codable {
    var imageUrl: String
    var name: String?
    var itemId : String
    
    init(imageUrl : String, name : String, itemId : String) {
        self.imageUrl = imageUrl
        self.name = name
        self.itemId = itemId
    }
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "atw"
        case name = "tracks"
        case itemId = "itemID"
    }
}

class GAPlaylistModel {
    var playlistName : String!
    var playlistSongs = [GAFeedModel]()
}

