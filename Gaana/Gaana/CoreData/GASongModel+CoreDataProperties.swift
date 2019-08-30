//
//  GASongModel+CoreDataProperties.swift
//  Gaana
//
//  Created by Pawan Agarwal on 31/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//
//

import Foundation
import CoreData


extension GASongModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GASongModel> {
        return NSFetchRequest<GASongModel>(entityName: "GASongModel")
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var itemId: String?
    @NSManaged public var name: String?
    @NSManaged public var playlist: GAPlaylistModel?

}

extension GASongModel {
    convenience init(modelDict : [String : Any]) {
        self.init(context: GACoreDataManager.sharedInstance.persistentContainer.viewContext)
        name = modelDict["name"] as? String
        imageUrl = modelDict["atw"] as? String ?? ""
        itemId = modelDict["itemId"] as? String ?? ""
    }
    
}
