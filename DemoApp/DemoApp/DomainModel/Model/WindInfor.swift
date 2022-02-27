//
//  WindInfor.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON

class WindInfor: NSObject {
    var speed: Double = 0.0
    var gust: Double = 0.0
    var deg: Double = 0.0
    var degSymbol: String = ""
    
    init(_ json: JSON) {
        super.init()
        speed = json["speed"].doubleValue
        gust = json["gust"].doubleValue
        deg = json["deg"].doubleValue
        
        if deg == 0 {
            degSymbol = "N"
        } else if deg > 0 && deg < 45 {
            degSymbol = "NNE"
        } else if deg == 45 {
            degSymbol = "NE"
        } else if deg > 45 && deg < 90 {
            degSymbol = "ENE"
        } else if deg == 90 {
            degSymbol = "E"
        } else if deg > 90 && deg < 135 {
            degSymbol = "ESE"
        } else if deg == 135 {
            degSymbol = "SE"
        } else if deg > 135 && deg < 180 {
            degSymbol = "SSE"
        } else if deg == 180 {
            degSymbol = "S"
        } else if deg > 180 && deg < 225 {
            degSymbol = "SSW"
        } else if deg == 225 {
            degSymbol = "SW"
        } else if deg > 225 && deg < 270 {
            degSymbol = "WSW"
        } else if deg == 270 {
            degSymbol = "W"
        } else if deg > 270 && deg < 315 {
            degSymbol = "WW"
        } else if deg == 315 {
            degSymbol = "NW"
        } else if deg > 315 && deg < 360 {
            degSymbol = "NNW"
        } else {
            degSymbol = "N"
        }
        
        /*
         North (N): 0° = 360°
         East (E): 90°
         South (S): 180°
         West (W): 270°
         */
    }
}
