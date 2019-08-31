//
//  GACoreDataManager.swift
//  GACoreData
//
//  Created by Pawan Agarwal on 26/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit
import CoreData

enum GADBEntityType: String {
    case playlist =  "GAPlaylistModel"
    case song     = "GASongModel"
}

extension NSManagedObject{
    
    func getPropertyDictionary()->[String:Any]?{
        let keys = Array(self.entity.attributesByName.keys)
        var dict: [String : Any]? = nil
        dict = self.dictionaryWithValues(forKeys: keys)
        return dict
    }
    
    func getRelationshipDictionary()->[String:Any]?{
        let keys = Array(self.entity.relationshipsByName.keys)
        var dict: [String : Any]? = nil
        dict = self.dictionaryWithValues(forKeys: keys)
        return dict
    }
}

extension Dictionary {
    public mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

final class GACoreDataManager:NSObject {
    
    //Shared Instance
    static let sharedInstance = GACoreDataManager()
    private override init() {}  //Private protection of init
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "GACoreDataContainer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        })
        return container
    }()
    
    
    lazy var privateContext:NSManagedObjectContext  = persistentContainer.newBackgroundContext()
    lazy var dummyContext:NSManagedObjectContext  = persistentContainer.newBackgroundContext()

    // MARK: - Core Data Saving
    func saveContext () -> Error?{
        //To save private context changes
        if privateContext.hasChanges{
            do{
                try privateContext.save()
            }catch{
                return error
            }
        }
        //To save main context changes
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                return error
            }
        }
        return nil
    }
}

extension GACoreDataManager {
    @discardableResult
    func addSongToNewPlaylist(name : String, songModel : GASongModel) -> Error? {
        let playlist:GAPlaylistModel? = getPlaylist(withName: name)

        let songEntityModel:GASongModel? = self.getSongFor(songModel: songModel)
        if let entityModel = songEntityModel {
            playlist?.addToSongs(entityModel )
        } else {
            if let playlist = playlist {
                getSongFor(songModel: songModel)?.addToPlaylist(playlist)
            }
        }
        return saveContext()
    }
    // Add song to Selected Playlists
    @discardableResult
    func addSongToPlaylists(playlists : [GAPlaylistModel], songModel : GASongModel) -> Error? {
        if let song = getSongFor(songModel: songModel) {
            for playlist in playlists {
                if let name = playlist.name, name.isEmpty == false {
                    getPlaylist(withName: name)?.addToSongs(song)
                }
            }
        }

        return saveContext()
    }

    // Deletes the Playlist
    @discardableResult
    func removePlaylist(name : String) -> Error? {
        if let result = getPlaylist(withName: name) {
            GACoreDataManager.sharedInstance.privateContext.delete(result)
        }
        return saveContext()
    }

    // Returns Song Model 
    func getSongFor(songModel: GASongModel) -> GASongModel? {
        var song: GASongModel?

        if songModel.managedObjectContext == GACoreDataManager.sharedInstance.privateContext {
            song = songModel
        } else {
            if let itemId = songModel.itemId {
                let request = NSFetchRequest<GASongModel>(entityName: GADBEntityType.song.rawValue)
                request.predicate = NSPredicate(format: "itemId = %@", itemId)
                if let result = try? GACoreDataManager.sharedInstance.privateContext.fetch(request), result.count > 0{
                    song = result[0]
                } else {
                    let songEntityModel:GASongModel? = NSEntityDescription.insertNewObject(forEntityName: GADBEntityType.song.rawValue, into: GACoreDataManager.sharedInstance.privateContext) as? GASongModel
                    songEntityModel?.name = songModel.name ?? ""
                    songEntityModel?.imageUrl = songModel.imageUrl
                    songEntityModel?.itemId = songModel.itemId
                    songEntityModel?.addedOn = NSDate()
                    song = songEntityModel
                }
            }
        }
        return song
    }
    
    func getPlaylist(withName: String) -> GAPlaylistModel? {
        var playList: GAPlaylistModel?

        let request = NSFetchRequest<GAPlaylistModel>(entityName: GADBEntityType.playlist.rawValue)
        request.predicate = NSPredicate(format: "name = %@", withName)
        if let result = try? GACoreDataManager.sharedInstance.privateContext.fetch(request), result.count > 0{
            playList = result[0]
        } else {
            playList = NSEntityDescription.insertNewObject(forEntityName: GADBEntityType.playlist.rawValue, into: GACoreDataManager.sharedInstance.privateContext) as? GAPlaylistModel
            playList?.name = withName
            _ = saveContext()
        }
        return playList
    }

    @discardableResult
    func updatePlaylist(name : String,songModel : GASongModel) -> Error? {

        if let playlist = getPlaylist(withName: name), let songs = playlist.songs?.allObjects as? [GASongModel]{
            for song in songs {
                if song.itemId == songModel.itemId {
                    playlist.removeFromSongs(song)
                }
            }
        }
        return saveContext()
    }
    
    func getAllPlaylists(songId: String? = nil) -> [GAPlaylistModel] {
        let request = NSFetchRequest<GAPlaylistModel>(entityName: GADBEntityType.playlist.rawValue)
        request.relationshipKeyPathsForPrefetching = ["songs","playlist"]
        do {
            var result = try GACoreDataManager.sharedInstance.privateContext.fetch(request)
            if let songId = songId, songId.isEmpty == false {
                result = result.filter { (playlist) -> Bool in
                    if let songs = playlist.songs?.allObjects as? [GASongModel] {
                        var found = false
                        for song in songs {
                            if song.itemId == songId {
                                found = true
                                break
                            }
                        }
                        return !found
                    }
                    return true
                }
            }
            return result
        } catch {
            print("Failed")
        }
        return [GAPlaylistModel]()
        
    }
}
