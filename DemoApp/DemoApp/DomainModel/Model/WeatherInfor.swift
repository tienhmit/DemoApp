//
//  WeatherInfor.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON

class WeatherInfor: NSObject {
    var desc: String = ""
    var id: Int = 0
    var main: String = ""
    var icon: String = ""
    
    init(_ json: JSON) {
        desc = json["description"].stringValue
        id = json["id"].intValue
        main = json["main"].stringValue
        icon = json["icon"].stringValue
    }
}
