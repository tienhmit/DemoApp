//
//  LocationDetailViewController.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import Foundation
import UIKit

class LocationDetailView: BaseViewController {
    private var presenter = LocationDetailPresenter.shared
    var viewModel = LocationDetailViewModel()
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblUV: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblDewPoint: UILabel!
    @IBOutlet weak var lblVisibility: UILabel!
    @IBOutlet weak var imvWeather: UIImageView!
    @IBOutlet weak var lblWeatherDesc: UILabel!
    @IBOutlet weak var imvCurrentLocation: UIImageView!
    @IBOutlet weak var imvWind: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadView()
        presenter.locationDetailDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK:
    // MARK:  IBACTIONS
    @IBAction func btnClosePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension LocationDetailView: LocationDetailDelegate {
    func reloadView() {
        lblUV.text = "UV index" + ": -"
        imvCurrentLocation.isHidden = !viewModel.getIsCurrentLocation()
        
        guard let data = viewModel.getForcastWeatherData()?.current else {
            lblLocationName.text = "Current Location"
            lblTemp.text = "-"
            lblWind.text = "Wind" + ": -"
            lblHumidity.text = "Humidity" + ": -"
            lblPressure.text = "Pressure" + ": -"
            lblVisibility.text = "Visibility" + ": -"
            lblDewPoint.text = "Dew point" + ": -"
            lblWeatherDesc.text = ""
            imvWeather.image = nil
            imvWind.isHidden = true
            lblLocationName.text = "-"
            lblUV.text = "UV index" + ": -"
            return
        }
        
        imvWind.isHidden = false
        imvWind.transform = CGAffineTransform(rotationAngle: CGFloat(data.wind_deg*(Double.pi/180)))
        
        lblLocationName.text = viewModel.getLocationName()?.capitalized
        lblTemp.text = String(format: "%.0f°C", data.temp.tempK2C)
        lblWind.text = String(format: "%@: %.1fm/s %@", "Wind", data.wind_speed, data.wind_deg.windDegSymbol)
        lblHumidity.text = "Humidity" + ": \(Int(data.humidity))%"
        
        lblPressure.text = "Pressure" + ": \(Int(data.pressure))hPa"
        lblVisibility.text = String(format: "%@: %.1fkm", "Visibility", data.visibility/1000)
        lblDewPoint.text = String(format: "%@: %.0f°C", "Dew point" , data.dew_point.tempK2C)
        lblUV.text = "UV index" + ": \(data.uvi)"
        
        let weather = data.weather.first
        lblWeatherDesc.text = weather?.desc.capitalizingFirstLetter()
        
        if let icon = weather?.icon, !icon.isEmpty {
            imvWeather.image = UIImage(named: icon)
        } else {
            imvWeather.image = nil
        }
    }
}
