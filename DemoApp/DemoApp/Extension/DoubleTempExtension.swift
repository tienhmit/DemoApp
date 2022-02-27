//
//  DoubleExtension.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

extension Double {
    var tempK2C: Double {
        let temp_K = 273.15
        return self - temp_K
    }
    
    var windDegSymbol: String {
        let deg = self
        var degSymbol = ""
        
        if deg == 0 {
            degSymbol = "N"
        } else if deg > 0.0 && deg < 45.0 {
            degSymbol = "NNE"
        } else if deg == 45.0 {
            degSymbol = "NE"
        } else if deg > 45.0 && deg < 90.0 {
            degSymbol = "ENE"
        } else if deg == 90.0 {
            degSymbol = "E"
        } else if deg > 90.0 && deg < 135.0  {
            degSymbol = "ESE"
        } else if deg == 135.0 {
            degSymbol = "SE"
        } else if deg > 135.0 && deg < 180.0 {
            degSymbol = "SSE"
        } else if deg == 180.0 {
            degSymbol = "S"
        } else if deg > 180.0 && deg < 225.0 {
            degSymbol = "SSW"
        } else if deg == 225.0 {
            degSymbol = "SW"
        } else if deg > 225.0 && deg < 270.0 {
            degSymbol = "WSW"
        } else if deg == 270.0 {
            degSymbol = "W"
        } else if deg > 270.0 && deg < 315.0 {
            degSymbol = "WW"
        } else if deg == 315.0 {
            degSymbol = "NW"
        } else if deg > 315.0 && deg < 360.0 {
            degSymbol = "NNW"
        } else {
            degSymbol = "N"
        }
        
        return degSymbol
    }
}
