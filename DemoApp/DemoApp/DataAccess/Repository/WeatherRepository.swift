//
//  WeatherRepository.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import SwiftyJSON
import Alamofire

protocol WeatherRepositoryInterface {
    func currentLocation(latitude: String,
                         longitude: String,
                         complete: @escaping((_ data: LocationWeatherDataModel) -> Void),
                         failure: @escaping((_ err: Error) -> Void))
    func anyLocation(latitude: String,
                     longitude: String,
                     complete: @escaping((_ data: ForecastWeatherDataModel) -> Void),
                     failure: @escaping((_ err: Error) -> Void))
}

struct WeatherRepository {
    private let fetcher: BaseFetcherInterface
    
    init(fetcher: BaseFetcherInterface = BaseFetcher.shared) {
        self.fetcher = fetcher
    }
}

extension WeatherRepository: WeatherRepositoryInterface {
    func currentLocation(latitude: String,
                         longitude: String,
                         complete: @escaping ((LocationWeatherDataModel) -> Void),
                         failure: @escaping ((Error) -> Void)) {
        fetcher.fetchRequest(
            requestConditions: WeatherRequestConditionsType.currentlocation(latitude, longitude),
            complete: { json in
                complete(LocationWeatherDataModel(from: json))},
            failure: { error in
                failure(error)}
        )
    }
    
    func anyLocation(latitude: String,
                     longitude: String,
                     complete: @escaping ((ForecastWeatherDataModel) -> Void),
                     failure: @escaping ((Error) -> Void)) {
        fetcher.fetchRequest(
            requestConditions: WeatherRequestConditionsType.currentlocation(latitude, longitude),
            complete: { json in
                complete(ForecastWeatherDataModel(from: json))},
            failure: { error in
                failure(error)}
        )
    }
}

enum WeatherRequestConditionsType {
    case currentlocation(String, String)
    case anyLocation(String, String)
}

extension WeatherRequestConditionsType: RequestConditions {
    var baseURL: String {
        "http://api.openweathermap.org/data/2.5"
    }
    
    var apiURL: String {
        switch self {
        case .currentlocation:
            return "/weather"
        case .anyLocation:
            return "/onecall"
        }
    }
    
    var params: Dictionary<String, Any> {
        switch self {
        case let .currentlocation(latitude, longitude), let .anyLocation(latitude, longitude):
            return ["lat": latitude,
                    "lon": longitude,
                    "appid": "4d1a1b39868241cfc34a0c7c8f1186e6"]
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var dataType: APIDataType {
        .querryString
    }
}
