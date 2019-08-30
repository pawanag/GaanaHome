//
//  GAPlaylistModel+CoreDataProperties.swift
//  Gaana
//
//  Created by Pawan Agarwal on 31/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//
//

import Foundation
import CoreData


extension GAPlaylistModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GAPlaylistModel> {
        return NSFetchRequest<GAPlaylistModel>(entityName: "GAPlaylistModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var songs: NSSet?

}

// MARK: Generated accessors for songs
extension GAPlaylistModel {

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: GASongModel)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: GASongModel)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSSet)

}
