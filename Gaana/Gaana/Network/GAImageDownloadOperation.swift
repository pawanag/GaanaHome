//
//  GAImageDownloadOperation.swift
//  Gaana
//
//  Created by Pawan Agarwal on 25/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

typealias GAImageDownloadHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

class GAImageDownloadOperation : GAAsyncOperation {
    
    //MARK:- variables
    let imageUrl : URL!
    var downloadHandler: GAImageDownloadHandler?
    private let indexPath: IndexPath!
    
    //MARK:- methods
    override func main() {
        downloadImageFromUrl()
    }
    
    required init (url: URL, indexPath: IndexPath?) {
        self.imageUrl = url
        self.indexPath = indexPath
    }
    
    func downloadImageFromUrl() {
        let newSession = URLSession.shared
        let downloadTask = newSession.downloadTask(with: imageUrl) { (location, response, error) in
            debugPrint("row \(self.indexPath.row) && error = \(error?.localizedDescription)")
            if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
                let image = UIImage(data: data)
                self.downloadHandler?(image,self.imageUrl, self.indexPath,error)
            }
            self.state = .finished
        }
        downloadTask.resume()
    }
}
