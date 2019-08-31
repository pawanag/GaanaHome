//
//  GAServiceHandler.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

class GAServiceHandler: NSObject {
    
    let connectionHandler : NetworkRegistrar
    
    init(_ connectionHandler : NetworkRegistrar = GANetworkRegistrar()) {
        self.connectionHandler = connectionHandler
    }
    
    func fetchHomeData(urlString : String, completion :@escaping (_ songsArr : [GAHomeMainModel])-> Void) {
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        let urlRequest = URLRequest(url: url)
        connectionHandler.initRequest(request: urlRequest, withSuccess: { (data, response) in
            //
            do {
                if let dataResp = data, let jsonData = ((try? JSONSerialization.jsonObject(with: dataResp, options: .allowFragments) as? [String : Any]) as [String : Any]??){
                    //append feed array and return
                    if let feedArr = jsonData?["sections"] as? [[String : Any]]{
                        var mainModels = [GAHomeMainModel]()
                        for (_,dictObj) in feedArr.enumerated(){
                            let model = GAHomeMainModel(modelDict: dictObj)
//                            model.viewType =  FeedMainModelType(rawValue: index) ?? FeedMainModelType.one
                            mainModels.append(model)
                        }
                        completion(mainModels)
                    }else{
                        completion([])
                    }
                }else{
                    completion([])
                }
            } 
        }) { (data, response, error) in
            //
        }
        
    }
}
