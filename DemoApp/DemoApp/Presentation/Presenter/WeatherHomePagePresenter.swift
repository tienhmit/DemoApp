//
//  WeatherHomePagePresenter.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherHomePageDelegate {
    func reloadView()
}

class WeatherHomePagePresenter: NSObject {
    
    static let shared = WeatherHomePagePresenter()
    var weatherHomePageDelegate: WeatherHomePageDelegate? = nil
    
    private let locationHelper = LocationHelper()
    private let weatherUseCase: WeatherUseCaseInterface
    var lastTimeUpdate: Date = Date()
    var listFavorite = DataManager.shared.getListLocationFavorite()
    var mapForecastWeatherData: [String: ForecastWeatherDataModel] = [:]
    var currentLocationWeatherData: LocationWeatherDataModel?
    
    var title: String {
        "Weather Demo"
    }
    
    var lastTimeString: String {
        if lastTimeUpdate.isInToday {
            return "Updated" + ": " + "Today at" + " " + lastTimeUpdate.toStringWithFormat("HH:mm:ss")
        }
        return "Updated" + ": " + lastTimeUpdate.toStringWithFormat("HH:mm:ss - dd MMM, YYYY")
    }
    
    var listLocationCount: Int {
        listFavorite.count
    }
    
    private init(weatherUseCase: WeatherUseCaseInterface = WeatherUseCase()) {
        self.weatherUseCase = weatherUseCase
    }
    
    private func doGetCurrentLocationData() {
        locationHelper.getCurrentLocation ({ [weak self] (location: CLLocation) in
            self?.doGetForecastWeatherData(key: "current", coordinate: location.coordinate)
            self?.doGetCurrentLocationData(coordinate: location.coordinate)
            }, { [weak self] (status: CLAuthorizationStatus) in
                self?.weatherHomePageDelegate?.reloadView()
        })
    }
    
    func getCurrentLocationForecastWeatherData() -> ForecastWeatherDataModel? {
        return mapForecastWeatherData["current"]
    }
    
    func updateForecaseWeatherData(key: String, data: ForecastWeatherDataModel?) {
        guard let data = data else {
            mapForecastWeatherData[key] = nil
            return
        }
        
        mapForecastWeatherData[key] = data
        lastTimeUpdate = Date()
    }
    
    func addFavorite(_ location: LocationModel) {
        let result = listFavorite.filter { (item: LocationModel) in
            return item.id == location.id
        }
        
        if result.isEmpty {
            listFavorite.append(location)
            DataManager.shared.saveListFavoriteLocation(listFavorite)
        }
    }
    
    func removeFavorite(_ location: LocationModel) {
        listFavorite.removeAll { (item: LocationModel) in
            return item.id == location.id
        }
        DataManager.shared.saveListFavoriteLocation(listFavorite)
    }
    
    func updateCurrentLocationWeatherData(data: LocationWeatherDataModel) {
        currentLocationWeatherData = data
        lastTimeUpdate = Date()
    }
    
    func getLocation(index: Int) -> LocationModel? {
        return listFavorite.count > index ? listFavorite[index] : nil
    }
    
    func getLocationForecastData(index: Int) -> ForecastWeatherDataModel? {
        guard let location = getLocation(index: index) else {
            return nil
        }
        return mapForecastWeatherData[location.id]
    }
    
    func viewDidAppear() {
        doPullToRefresh()
    }
    
    func doPullToRefresh() {
        doGetCurrentLocationData()
        for item in listFavorite {
            weatherUseCase.anyLocation(
                latitude: "\(item.lat)",
                longitude: "\(item.long)",
                complete: { [weak self] (data: ForecastWeatherDataModel) in
                    self?.didGetForecastWeatherData(key: item.id, data: data)
                },
                failure: {[weak self] (error: Error) in
                    self?.didRequestFailed(err: error)
            })
        }
    }
    
    func didGetForecastWeatherData(key: String, data: ForecastWeatherDataModel) {
        updateForecaseWeatherData(key: key, data: data)
        weatherHomePageDelegate?.reloadView()
    }
    
    func didCurrentLocationWeatherData(data: LocationWeatherDataModel) {
        updateCurrentLocationWeatherData(data: data)
        weatherHomePageDelegate?.reloadView()
    }
    
    func didRequestFailed(err: Error) {
        
    }
    
    func didSelectLocation(_ location: LocationModel) {
        addFavorite(location)
        weatherHomePageDelegate?.reloadView()
        weatherUseCase.anyLocation(
            latitude: "\(location.lat)",
            longitude: "\(location.long)",
            complete: { [weak self] (data: ForecastWeatherDataModel) in
                self?.didGetForecastWeatherData(key: location.id, data: data)
            },
            failure: {[weak self] (error: Error) in
                self?.didRequestFailed(err: error)
        })
    }
    
    func doGetCurrentLocationData(coordinate: CLLocationCoordinate2D) {
        let latitude = "\(coordinate.latitude)"
        let longitude = "\(coordinate.longitude)"
        weatherUseCase.currentLocation(
            latitude: latitude,
            longitude: longitude,
            complete: { [weak self] (data: LocationWeatherDataModel) in
                self?.didCurrentLocationWeatherData(data: data)
            },
            failure: { [weak self] (error: Error) in
                self?.didRequestFailed(err: error)
        })
    }
    
    func doGetForecastWeatherData(key: String, coordinate: CLLocationCoordinate2D) {
        let latitude = "\(coordinate.latitude)"
        let longitude = "\(coordinate.longitude)"
        weatherUseCase.anyLocation(
            latitude: latitude,
            longitude: longitude,
            complete: { [weak self] (data: ForecastWeatherDataModel) in
                self?.didGetForecastWeatherData(key: key, data: data)
            },
            failure: {[weak self] (error: Error) in
                self?.didRequestFailed(err: error)
        })
    }
    
    func selectLocationAction(_ viewController: UIViewController) {
        let ids = listFavorite.map { $0.id }
        
        SelectLocationViewController.doSelectLocation(from: viewController, selectedLocationIds: ids)
        { [weak self] location in
            self?.didSelectLocation(location)
        }
    }
    
    func doViewCurrentLocationDetail(_ viewController: UIViewController) {
        guard let weatherData = currentLocationWeatherData,
            let forecastData = getCurrentLocationForecastWeatherData() else {
                return
        }
        
        let vc = LocationDetailView.initWithDefaultNib()
        
        vc.viewModel = LocationDetailViewModel(lat: weatherData.lat,
                                               long: weatherData.long,
                                               locationName: weatherData.name,
                                               isCurrentLocation: true,
                                               dataDetail: forecastData)
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true, completion: nil)
    }
    
    func doSelectLocation(with rowNumber: Int, by viewController: UIViewController) {
        guard let location = getLocation(index: rowNumber),
            let forecastData = getLocationForecastData(index: rowNumber) else {
                return
        }
        let vc = LocationDetailView.initWithDefaultNib()
        vc.viewModel = LocationDetailViewModel(lat: location.lat,
                                               long: location.long,
                                               locationName: location.name,
                                               isCurrentLocation: true,
                                               dataDetail: forecastData)
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true, completion: nil)
    }
    
    func doRemoveLocationFromFavoriteList(_ location: LocationModel) {
        listFavorite.removeAll { (item: LocationModel) in
            return item.id == location.id
        }
        DataManager.shared.saveListFavoriteLocation(listFavorite)
        weatherHomePageDelegate?.reloadView()
    }
}
