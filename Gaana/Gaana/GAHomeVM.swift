//
//  GAHomeVM.swift
//  Gaana
//
//  Created by Pawan Agarwal on 24/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import UIKit

enum GAHViewModelAction : Int {
    case none
    case reloadData
}

class GAHomeVM: NSObject {
    
    var numberOfRows : Int?
    var modelData = [GAHomeMainModel]()
    var completionHandler : ((_ action : GAHViewModelAction) -> Void)?
    private var serviceHandler: GAServiceHandler
    
    init(webserviceHandler: GAServiceHandler = GAServiceHandler()) {
        serviceHandler = webserviceHandler
        super.init()
    }
    
    func fetchHomeData() {
        serviceHandler.fetchHomeData(urlString: "https://demo3033278.mockable.io/gaanaDriveTest") {[weak self] (homeModel) in
            self?.modelData = homeModel

            for i in 0..<homeModel.count {
                let viewType = GAViewType(rawValue: i) ?? GAViewType.unknown
                self?.modelData[i].viewType = viewType
            }
            DispatchQueue.main.async {
                self?.completionHandler?(.reloadData)
            }
            //            print(homeModel)
        }
    }
}
