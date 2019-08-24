//
//  GAUtility.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

let errorDomain = "com.gaana.iosapp"

class GAUtility: NSObject {
    class func noInternetError() -> NSError? {
        let error = NSError(domain: errorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "No Internet", NSLocalizedFailureReasonErrorKey: "Please check your Internet connection and try again.", NSLocalizedRecoveryOptionsErrorKey: ["Retry", "Cancel"]])
        return error
    }
    
    class func isNetworkReachable() -> Bool {
        return (Reachability()?.currentReachabilityStatus != .notReachable);
    }
    
}
