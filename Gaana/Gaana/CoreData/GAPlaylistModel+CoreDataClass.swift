//
//  GAPlaylistModel+CoreDataClass.swift
//  Gaana
//
//  Created by Pawan Agarwal on 31/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GAPlaylistModel)
public class GAPlaylistModel: NSManagedObject {

}

extension GASongModel {
    convenience init(modelDict : [String : Any]) {
        self.init(context: GACoreDataManager.sharedInstance.dummyContext)
        name = modelDict["name"] as? String
        imageUrl = modelDict["atw"] as? String ?? ""
        itemId = modelDict["itemID"] as? String ?? ""
    }

}

