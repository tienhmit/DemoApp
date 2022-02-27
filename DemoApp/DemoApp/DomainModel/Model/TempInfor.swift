//
//  TempInfor.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON

class TempInfor: NSObject {
    var sea_level: Double = 0.0
    var temp_min: Double = 0.0
    var temp_max: Double = 0.0
    var temp: Double = 0.0
    var pressure: Double = 0.0
    var feels_like: Double = 0.0
    var humidity: Double = 0.0
    var grnd_level: Double = 0.0
    
    init(_ json: JSON) {
        sea_level = json["sea_level"].doubleValue
        temp_min = json["temp_min"].doubleValue
        temp_max = json["temp_max"].doubleValue
        temp = json["temp"].doubleValue
        pressure = json["pressure"].doubleValue
        feels_like = json["feels_like"].doubleValue
        humidity = json["humidity"].doubleValue
        grnd_level = json["grnd_level"].doubleValue
    }
    
    private let temp_K = 273.15
    
    var temp_min_C: Double {
        return temp_min - temp_K
    }
    
    var temp_max_C: Double {
        return temp_max - temp_K
    }
    
    var temp_C: Double {
        return temp - temp_K
    }
}
