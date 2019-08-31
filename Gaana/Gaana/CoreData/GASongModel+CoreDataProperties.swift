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
    @NSManaged public var addedOn: NSDate?
    @NSManaged public var playlist: NSSet?

}

// MARK: Generated accessors for playlist
extension GASongModel {

    @objc(addPlaylistObject:)
    @NSManaged public func addToPlaylist(_ value: GAPlaylistModel)

    @objc(removePlaylistObject:)
    @NSManaged public func removeFromPlaylist(_ value: GAPlaylistModel)

    @objc(addPlaylist:)
    @NSManaged public func addToPlaylist(_ values: NSSet)

    @objc(removePlaylist:)
    @NSManaged public func removeFromPlaylist(_ values: NSSet)

}
