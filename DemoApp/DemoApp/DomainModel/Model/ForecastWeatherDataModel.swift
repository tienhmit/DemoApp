//
//  ForecastWeatherDataModel.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON

class ForecastWeatherDataModel: NSObject {
    var current: ForecaseInfor = ForecaseInfor()
    var hourly: [ForecaseInfor] = []
    
    override init() {
        current = ForecaseInfor()
        super.init()
    }
    
    init(from json: JSON) {
        current = ForecaseInfor(json["current"])
        
        for sub in json["hourly"].arrayValue {
            hourly.append(ForecaseInfor(sub))
        }
    }
}
