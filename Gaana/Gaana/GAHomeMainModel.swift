//
//  GAHomeMainModel.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

let kcellPadding : CGFloat = 120
import CoreData

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

struct GAHomeModel {
    var status : Int
    var sections : [GAHomeMainModel]
    enum CodingKeys: String, CodingKey {
        case status
        case sections = "sections"
    }
}

struct GAHomeMainModel {
    var name : String
    var tracks = [GASongModel]()
    var viewType: GAViewType = .unknown
    
    
        init(modelDict : [String: Any]) {
            name = modelDict["name"] as? String ?? ""
            if let tracks1 = modelDict["tracks"] as? [[String : Any]]{
                for obj in tracks1{
                    let obj = GASongModel(modelDict: obj)
                    tracks.append(obj)
                }
            }
        }
}
