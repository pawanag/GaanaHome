//
//  GATestUtility.swift
//  GaanaTests
//
//  Created by Pawan Agarwal on 25/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import XCTest

class GATestUtility: NSObject {
    func dataFromJSONFile(filePath: String) -> NSData?
    {
        guard let data = openJSONFile(fileName: filePath) else
        {
            return NSData()
        }
        return data
    }
    
    private func openJSONFile(fileName: String) -> NSData?
    {
        guard let filePath = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else
        {
            return nil
        }
        return NSData(contentsOfFile:filePath)
    }
}
