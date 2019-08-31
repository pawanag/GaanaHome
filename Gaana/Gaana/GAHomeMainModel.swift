//
//  GAHomeMainModel.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import CoreData
import UIKit


enum GAViewType: Int{
    case largeSquareHS, smallSqaureHS, circularHS, rectangularHS, gridVS, unknown
    //private var
    private var kCellOuterPadding: CGFloat{
        return 110
    }
    
    private var labelPadding: CGFloat{
        return font.lineHeight * 2
    }
    
    //exposed variables
    var cellSize: CGSize{
        switch self {
        case .largeSquareHS, .circularHS:
            return CGSize(width: 155, height: 155)
        case .smallSqaureHS:
            return CGSize(width: 70, height: 70)
        case .rectangularHS:
            return CGSize(width: 155, height: 90)
        case .gridVS:
            return CGSize(width: 160, height: 160)
        default:
            return .zero
        }
    }
    
    var cellImageCornerRadius : CGFloat{
        if self == .circularHS{
            return cellSize.height/2
        }else{
            return 0
        }
        
    }
    
    var font: UIFont{
        switch self {
        case .largeSquareHS, .circularHS, .rectangularHS, .gridVS:
            return UIFont.systemFont(ofSize: 16)
        case .smallSqaureHS:
            return UIFont.systemFont(ofSize: 12)
        default:
            return UIFont.systemFont(ofSize: 0)
        }
    }
    
    var cumulativeCellHeight: CGFloat{
        var height = collectionCellSize.height + kCellOuterPadding
        if self == .gridVS{
            height = height + collectionCellSize.height
        }
        return height
    }
    
    var collectionCellSize: CGSize{
        return CGSize(width: cellSize.width + 20, height: cellSize.height + labelPadding + 10)
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
