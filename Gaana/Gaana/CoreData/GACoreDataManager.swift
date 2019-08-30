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
    case playlist =  "PlaylistModel"
    case song     = "SongModel"
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
        let playlist:PlaylistModel? = NSEntityDescription.insertNewObject(forEntityName: GADBEntityType.playlist.rawValue, into: GACoreDataManager.sharedInstance.privateContext) as? PlaylistModel
        playlist?.name = name

        let songEntityModel:SongModel? = NSEntityDescription.insertNewObject(forEntityName: GADBEntityType.song.rawValue, into: GACoreDataManager.sharedInstance.privateContext) as? SongModel
        songEntityModel?.name = songModel.name ?? ""
        songEntityModel?.imageUrl = songModel.imageUrl
        songEntityModel?.itemId = songModel.itemId
//        playlist?.addToFeeds(song ?? GASongModel())
        saveContext()
    }
    
    
    
    func getAllPlaylists() -> [PlaylistModel] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: GADBEntityType.playlist.rawValue)
        //request.predicate = NSPredicate(format: "age = %@", "12")
        //        request.returnsObjectsAsFaults = false
        do {
            let result = try GACoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
            if let resultData = result as? [PlaylistModel] {
                return resultData
//                for model in resultData {
////                    print(model.name)
//                }
            }
        } catch {
            print("Failed")
        }
        return [PlaylistModel]()

    }

    
    private func saveSongModel(model : SongModel) {
        
        let song:SongModel? = NSEntityDescription.insertNewObject(forEntityName: GADBEntityType.song.rawValue, into: GACoreDataManager.sharedInstance.privateContext) as? SongModel
        song?.name = model.name ?? ""
        song?.imageUrl = model.imageUrl
        song?.itemId = model.itemId
        
        saveContext()
    }
    
    private func getData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: GADBEntityType.song.rawValue)
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try GACoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
            for data in result as! [NSManagedObject] {
                //                print(data.value(forKey: "name") as! String)
            }
            
        } catch {
            print("Failed")
        }
    }
}
