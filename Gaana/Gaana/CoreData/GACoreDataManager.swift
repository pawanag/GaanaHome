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
//            self.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//            self.persistentContainer.viewContext.undoManager = nil
//            self.persistentContainer.viewContext.shouldDeleteInaccessibleFaults = true

        })
        return container
    }()
    
    
    lazy var privateContext:NSManagedObjectContext  = persistentContainer.newBackgroundContext()
    
    // MARK: - Core Data Saving
    func saveContext () {
        //To save private context changes
        if privateContext.hasChanges{
            do{
                try privateContext.save()
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        
        //To save main context changes
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func documentDirectoryPath()->String{
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return paths[0]
    }
    
}

extension GACoreDataManager {
    
    func addSongToNewPlaylist(name : String, songModel : GASongModel) {
        let playlist:GAPlaylistModel? = NSEntityDescription.insertNewObject(forEntityName: GADBEntityType.playlist.rawValue, into: GACoreDataManager.sharedInstance.privateContext) as? GAPlaylistModel
        playlist?.name = name
        
        let songEntityModel:GASongModel? = NSEntityDescription.insertNewObject(forEntityName: GADBEntityType.song.rawValue, into: GACoreDataManager.sharedInstance.privateContext) as? GASongModel
        songEntityModel?.name = songModel.name ?? ""
        songEntityModel?.imageUrl = songModel.imageUrl
        songEntityModel?.itemId = songModel.itemId
        if let entityModel = songEntityModel {
            playlist?.addToSongs(entityModel )
        }
        saveContext()
    }
    
    func addSongToPlaylists(playlists : [GAPlaylistModel], songModel : GASongModel) {
        //TODO
    }
    func removePlaylist(name : String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: GADBEntityType.playlist.rawValue)
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        
        if let result = try? GACoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(fetchRequest) {
            for object in result {
                GACoreDataManager.sharedInstance.persistentContainer.viewContext.delete(object as! NSManagedObject)
            }
        }
        saveContext()
    }
    func updatePlaylist(name : String,songModel : GASongModel) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: GADBEntityType.playlist.rawValue)
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let result = try? GACoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request), let resultFetched = result as? [GAPlaylistModel], let songs = resultFetched[0].songs?.allObjects as? [GASongModel]{
            for song in songs {
                if song.itemId == songModel.itemId {
                    GACoreDataManager.sharedInstance.persistentContainer.viewContext.delete(song as NSManagedObject)
                }
            }
        }
        saveContext()
    }
    
    func getAllPlaylists() -> [GAPlaylistModel] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: GADBEntityType.playlist.rawValue)
        request.relationshipKeyPathsForPrefetching = ["songs","playlist"]
        do {
            let result = try GACoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
            if let resultData = result as? [GAPlaylistModel] {
                return resultData
            }
        } catch {
            print("Failed")
        }
        return [GAPlaylistModel]()
        
    }
    
    
    private func saveSongModel(model : GASongModel) {
        let song:GASongModel? = NSEntityDescription.insertNewObject(forEntityName: GADBEntityType.song.rawValue, into: GACoreDataManager.sharedInstance.privateContext) as? GASongModel
        song?.name = model.name ?? ""
        song?.imageUrl = model.imageUrl
        song?.itemId = model.itemId
        saveContext()
    }

}
