//
//  LocationModel.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON

class LocationModel: NSObject {
    var id: String = ""
    var name: String = ""
    var state: String = ""
    var country: String = ""
    var lat: Double = 0.0
    var long: Double = 0.0
    var searchStr: String = ""
    
    init(dict: NSDictionary) {
        id = dict["id"] as? String ?? ""
        name = dict["name"] as? String ?? ""
        state = dict["state"] as? String ?? ""
        country = dict["country"] as? String ?? ""
        lat = dict["lat"] as? Double ?? 0.0
        long = dict["long"] as? Double ?? 0.0
        searchStr = name.searchString
    }
    
    init(json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        state = json["state"].stringValue
        country = json["country"].stringValue
        lat = json["coord"]["lat"].doubleValue
        long = json["coord"]["lon"].doubleValue
        searchStr = name.searchString
    }
    
    func toDict() -> Dictionary<String, Any> {
        return ["id" : id,
                "name": name,
                "state": state,
                "country": country,
                "lat": lat,
                "long": long]
    }
}
