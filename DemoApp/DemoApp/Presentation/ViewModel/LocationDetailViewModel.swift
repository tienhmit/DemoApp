//
//  LocationDetailViewModel.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit

class LocationDetailViewModel: NSObject {
    var lat: Double
    var long: Double
    var locationName: String
    var isCurrentLocation: Bool
    var dataDetail: ForecastWeatherDataModel
    
    init(lat: Double = 0.0,
         long: Double = 0.0,
         locationName: String = "",
         isCurrentLocation: Bool = false,
         dataDetail: ForecastWeatherDataModel = ForecastWeatherDataModel()) {
        self.lat = lat
        self.long = long
        self.locationName = locationName
        self.isCurrentLocation = isCurrentLocation
        self.dataDetail = dataDetail
    }
    
    func doUpdateForecastDat(_ data: ForecastWeatherDataModel) {
        dataDetail = data
    }
    
    func getLocationName() -> String? {
        return locationName
    }
    
    func getIsCurrentLocation() -> Bool {
        return isCurrentLocation
    }
    
    func getForcastWeatherData() -> ForecastWeatherDataModel? {
        return dataDetail
    }
}
