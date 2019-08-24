//
//  GAHomeMainModel.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

enum FeedMainModelType: Int{
    case one = 0, two, three, four, five
    
    var widthDimension: CGFloat{
        switch self {
        case .one:
            return 150
        case .two:
            return 75
        case .three:
            return 200
        case .four:
            return 150
        case .five:
            return 150
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
    var tracks : [FeedModel]
    enum CodingKeys: String, CodingKey {
        case name,tracks
    }
}

class FeedModel : Codable {
    var imageUrl: String
    var name: String?
    var itemId : String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "atw"
        case name = "tracks"
        case itemId = "itemID"
    }
}

