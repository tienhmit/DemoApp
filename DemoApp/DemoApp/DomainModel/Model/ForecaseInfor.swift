//
//  ForecaseInfor.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON

class ForecaseInfor: NSObject {
    var pressure: Double = 0.0
    var pop: Double = 0.0
    var dew_point: Double = 0.0
    var wind_speed: Double = 0.0
    var wind_deg: Double = 0.0
    var wind_gust: Double = 0.0
    var humidity: Double = 0.0
    var clouds: Double = 0.0
    var temp: Double = 0.0
    var feels_like: Double = 0.0
    var visibility: Double = 0.0
    var uvi: Double = 0.0
    var dt: Double = 0.0
    var weather: [WeatherInfor] = []
    
    init(_ json: JSON) {
        pressure = json["pressure"].doubleValue
        pop = json["pop"].doubleValue
        dew_point = json["dew_point"].doubleValue
        wind_speed = json["wind_speed"].doubleValue
        wind_deg = json["wind_deg"].doubleValue
        wind_gust = json["wind_gust"].doubleValue
        humidity = json["humidity"].doubleValue
        clouds = json["clouds"].doubleValue
        temp = json["temp"].doubleValue
        feels_like = json["feels_like"].doubleValue
        visibility = json["visibility"].doubleValue
        uvi = json["uvi"].doubleValue
        dt = json["dt"].doubleValue
        
        for sub in json["weather"].arrayValue {
            weather.append(WeatherInfor(sub))
        }
    }
    
    override init() {
        super.init()
    }
}
