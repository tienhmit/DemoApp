//
//  SysInfor.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON

class SysInfor: NSObject {
    var country: String = ""
    var sunset: Double = 0.0
    var sunrise: Double = 0.0
    
    init(_ json: JSON) {
        country = json["country"].stringValue
        sunset = json["sunset"].doubleValue
        sunrise = json["sunrise"].doubleValue
    }
}
