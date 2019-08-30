//
//  GAHomeMainModel.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

let kcellPadding : CGFloat = 120

import UIKit
enum GAViewType: Int{
    case largeSquareHS, smallSqaureHS, circularHS, rectangularHS, gridVS, unknown
    
    var cellWidth: CGFloat{
        switch self {
        case .largeSquareHS, .circularHS, .rectangularHS:
            return 175
        case .smallSqaureHS:
            return 90
        case .gridVS:
            return 180
        default:
            return 0
        }
    }
    
    
    var cellHeight : CGFloat{
        switch self {
        case .largeSquareHS, .circularHS:
            return 210
        case .rectangularHS:
            return 145
        case .smallSqaureHS:
            return 125
        case .gridVS:
            return 480 //2 rowcount
        default:
            return 0
        }
    }
}

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
    var viewType: GAViewType = .unknown
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
        case name = "name"
        case itemId = "itemID"
    }
}

class GAPlaylistModel {
    var playlistName : String!
    var playlistSongs = [GAFeedModel]()
}

