//
//  LocationDataManager.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit
import SwiftyJSON

class LocationDataManager: NSObject {
    static let shared: LocationDataManager = LocationDataManager()
    private var isFetchLocalData = false
    private var listAllLocation: [LocationModel] = []
    private var mapAllLocation: [String: LocationModel] = [:]
    
    override init() {
        super.init()
    }
    
    internal func doFetchDataLocal(complete: (() -> Void)?) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                guard let strongSelf = self else {
                    return
                }
                if let bundlePath = Bundle.main.path(forResource: "city.list", ofType: "json"),
                    let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                    let json = try JSON(data: jsonData)

                    var _list: [LocationModel] = []
                    var _map: [String: LocationModel] = [:]

                    for sub in json.arrayValue {
                        let item = LocationModel(json: sub)
                        _list.append(item)
                        _map[item.id] = item
                    }

                    DispatchQueue.main.async {
                        strongSelf.listAllLocation = _list
                        strongSelf.mapAllLocation = _map

                        strongSelf.isFetchLocalData = true
                        complete?()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.isFetchLocalData = true
                    complete?()
                }
            }
        }
    }
    
    func doSearchLocation(name: String, complete: ((_ result: [LocationModel]) -> Void)?) {
        if !isFetchLocalData {
            doFetchDataLocal { [weak self] in
                self?.doSearchLocation(name: name, complete: complete)
            }
        } else {
            DispatchQueue.global(qos: .background).async {  [weak self] in
                if let strong = self {
                    if name.isEmpty {
                        complete?(strong.listAllLocation)
                    } else {
                        let searchStr = name.searchString
                        
                        let result = strong.listAllLocation.filter { (item: LocationModel) in
                            let isExit = item.searchStr.contains(searchStr)
                            return isExit
                        }
                        
                        DispatchQueue.main.async {
                            complete?(result)
                        }
                    }
                }
            }
        }
    }
}
