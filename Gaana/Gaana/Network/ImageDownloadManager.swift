//
//  ImageDownloadManager.swift
//  Gaana
//
//  Created by Pawan Agarwal on 06/09/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class ImageOperation: Operation {
    
    let url : String?
    var customCompletionBlock: ((_ image : UIImage?,_ url: String) -> Void)?
    
    init(url : String, completionBlock : @escaping ((_ image : UIImage?,_ url : String) -> Void)) {
        self.url = url
        self.customCompletionBlock = completionBlock
    }
    
    override func main() {
        if self.isCancelled { return }
        if let url = self.url{
            if self.isCancelled { return }
            APIManager.shared.downloadImage(urlString: url) { (result) in
                DispatchQueue.main.async {
                    if let block = self.customCompletionBlock{
                        block(result, url)
                    }
                }
            }
        }
    }
}

typealias ImageClosure = (UIImage?,_ url: String) -> Void

class ImageDownloadManager: NSObject {
    static let shared = ImageDownloadManager()
    private(set) var cache:NSCache<AnyObject, AnyObject> = NSCache()
    
    private var operationQueue = OperationQueue()
    private var dictionaryBlocks = [UIImageView: (String, ImageClosure, ImageOperation)]()
    
    private override init() {
        operationQueue.maxConcurrentOperationCount = 100
    }
    
    func addOperation(url: String, imageView: UIImageView,completion: @escaping ImageClosure) {
        if let image = getImageFromCache(key: url)  {
            completion(image,url)
            if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                tupple.2.cancel()
            }
        } else {
            if !checkOperationExists(with: url,completion: completion) {
                if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                    tupple.2.cancel()
                }
                let newOperation = ImageOperation(url: url) { (image,downloadedImageURL) in
                    if let tupple = self.dictionaryBlocks[imageView] {
                        if tupple.0 == downloadedImageURL {
                            if let image = image {
                                self.saveImageToCache(key: downloadedImageURL, image: image)
                                tupple.1(image,downloadedImageURL)
                                if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                                    tupple.2.cancel()
                                }
                            } else {
                                // Failure
                            }
                            _ = self.dictionaryBlocks.removeValue(forKey: imageView)
                        }
                    }
                }
                dictionaryBlocks[imageView] = (url, completion, newOperation)
                operationQueue.addOperation(newOperation)
            }
        }
    }
    
    private func getImageFromCache(key : String) -> UIImage? {
        if (self.cache.object(forKey: key as AnyObject) != nil) {
            return self.cache.object(forKey: key as AnyObject) as? UIImage
        } else {
            return nil
        }
    }
    
    private func saveImageToCache(key : String, image : UIImage) {
        self.cache.setObject(image, forKey: key as AnyObject)
    }
    
    func checkOperationExists(with url: String,completion: @escaping (UIImage?,_ url: String) -> Void) -> Bool {
        if let arrayOperation = operationQueue.operations as? [ImageOperation] {
            let opeartions = arrayOperation.filter{$0.url == url}
            return opeartions.count > 0 ? true : false
        }
        return false
    }
}

extension UIImageView {
    func downloadImage(with url: String){
        ImageDownloadManager.shared.addOperation(url: url,imageView: self) {  [weak self](result,downloadedImageURL)  in
            DispatchQueue.main.async {
                if let image = result {
                    self?.image = image
                }
            }
        }
    }
}

class APIManager: NSObject {
    static let shared = APIManager()
    private override init() {}
    
    func downloadImage(urlString: String,completion: @escaping (UIImage?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        guard let url =  URL.init(string: urlString) else {
            return completion(nil)
        }
        
        session.downloadTask(with: url) { (url, reponse, error) in
            do {
                guard let url = url else {
                    return completion(nil)
                }
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    return completion(image)
                } else {
                    return completion(nil)
                }
            } catch {
                return completion(nil)
            }
            }.resume()
        
    }
}

