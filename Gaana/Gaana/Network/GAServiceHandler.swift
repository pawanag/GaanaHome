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
                let decoder = JSONDecoder()
                let mainModel = try decoder.decode(GAHomeModel.self, from: data!)
                let homeModel = mainModel.sections
                if homeModel.count > 0 {
                    completion(homeModel)
                }
                print(mainModel)
            } catch {
                print(error)
            }
        }) { (data, response, error) in
            //
        }
        
    }
}
