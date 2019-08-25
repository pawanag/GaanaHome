//
//  GAMockConnectionRegistrar.swift
//  GaanaTests
//
//  Created by Pawan Agarwal on 25/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import XCTest
@testable import Gaana

class GAMockConnectionRegistrar: NetworkRegistrar {
    
    enum GAHomeAPIJSONResponse: Int {
        case success = 0
        case error = 1
    }
    
    var responseJSON: GAHomeAPIJSONResponse = .success
    
    func initRequest(request: URLRequest, withSuccess successHandler: @escaping successHandler, withFailure failureHandler: @escaping failureHandler) {
        
        let response  = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = GATestUtility().dataFromJSONFile(filePath:resonseJSONFILE())
        if data != nil {
            do {
                try successHandler(data as Data?, response)
            }
            catch {
            }
        }
    }
    
    func resonseJSONFILE() -> String {
        switch responseJSON {
        case .success: return "GAHomePageSuccess"
        case .error: return "GAHomePageError"
        }
    }


}
