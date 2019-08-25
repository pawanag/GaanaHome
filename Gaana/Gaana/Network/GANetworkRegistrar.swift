//
//  GANetworkRegistrar.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

typealias successHandler = (_ data: Data?, _ response: URLResponse?) throws -> Void
typealias failureHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) throws -> Void

protocol NetworkRegistrar {
    func initRequest(request : URLRequest, withSuccess successHandler : @escaping successHandler, withFailure failureHandler : @escaping failureHandler)
}
class GANetworkRegistrar: NSObject, NetworkRegistrar, URLSessionDelegate {

    func initRequest(request : URLRequest, withSuccess successHandler : @escaping successHandler, withFailure failureHandler : @escaping failureHandler) {
        
        if(!GAUtility.isNetworkReachable()) {//network check
            do {
                try failureHandler(nil, nil, GAUtility.noInternetError());
                return
            }
            catch {
                assertionFailure("couldn't connect to server")
            }
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) { (data, response, error)-> Void in
            if let data = data {
                do {
                    try successHandler(data, response)
                }
                catch {
                    assertionFailure("couldn't")
                }
                
            } else {
                do {
                    try failureHandler(nil,nil,error)
                }
                catch {
                    assertionFailure("Error occured")
                }
            }
        }
        task.resume()
    }
}
