//
//  GACacheImageWrapper.swift
//  Gaana
//
//  Created by Pawan Agarwal on 25/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

final class GACacheImageWrapper {
    //MARK:- variables
    private var cache = NSCache<NSString, UIImage>()
    static let sharedInstance = GACacheImageWrapper()
    
    //MARK:- internal queue
    lazy private var imageDownloadQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "DownloadOperationQueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    //MARK:- private init
    private init(){}
    
    
    //MARK: methods
    func downloadImageWith(url: URL?, indexPath: IndexPath, completionHandler: @escaping GAImageDownloadHandler) {
        //early exit
        guard let imageUrl = url else{
            return
        }
        
        //check for cache
        if let image = self.cache.object(forKey: imageUrl.absoluteString as NSString) {
            completionHandler(image, imageUrl, indexPath, nil)
        } else {
            //check for exisiting operation
            if let operation = imageDownloadQueue.operations.filter({ (obj) -> Bool in
                if let downloadOperation = obj as? GAImageDownloadOperation{
                    return downloadOperation.imageUrl == imageUrl && downloadOperation.state == .executing
                }
                return false
            }).first{
                //increase priority
                operation.queuePriority = .veryHigh
            }
                //create a new task
            else{
                let operation = GAImageDownloadOperation(url: imageUrl, indexPath: indexPath)
                operation.downloadHandler = { [weak self](image, url, indexPath, error) in
                    guard let weakSelf = self else{
                        return
                    }
                    if let newImage = image {
                        weakSelf.cache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                    DispatchQueue.main.async {
                        completionHandler(image, url, indexPath, error)
                    }
                }
                operation.queuePriority = .high
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    func slowDownImageDownLoadTask(url: URL?){
        guard let imageUrl = url else{
            return
        }
        
        if let operation = imageDownloadQueue.operations.filter({ (obj) -> Bool in
            if let imageTask = obj as? GAImageDownloadOperation{
                return imageTask.imageUrl == imageUrl && imageTask.state == .executing
            }
            return false
        }).first{
            operation.queuePriority = .low
        }
    }
}
