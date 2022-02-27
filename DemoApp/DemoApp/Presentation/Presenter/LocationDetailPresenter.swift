//
//  LocationDetailPresenter.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import Foundation
import UIKit

protocol LocationDetailDelegate {
    func reloadView()
}

class LocationDetailPresenter: NSObject {
    
    static let shared = LocationDetailPresenter()
    var locationDetailDelegate: LocationDetailDelegate? = nil
    private let weatherUseCase: WeatherUseCaseInterface
    
    private init(weatherUseCase: WeatherUseCaseInterface = WeatherUseCase()) {
        self.weatherUseCase = weatherUseCase
    }
    
    func doGetForecastWeatherData(_ lat: Double, _ long: Double) {
        weatherUseCase.anyLocation(
            latitude: "\(lat)",
            longitude: "\(long)",
            complete: { [weak self] (data: ForecastWeatherDataModel) in
                self?.didGetData(data)
            },
            failure: { [weak self] (error: Error) in
                self?.didGetFailed(error)
        })
    }
    
    func didGetData(_ data: ForecastWeatherDataModel) {
        locationDetailDelegate?.reloadView()
    }
    
    func didGetFailed(_ err: Error) {
        
    }
}
