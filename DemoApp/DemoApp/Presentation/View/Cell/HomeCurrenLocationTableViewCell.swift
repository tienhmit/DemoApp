//
//  HomeCurrenLocationTableViewCell.swift
//  WindyDemo2
//
//  Created by Đào Mỹ Đông on 25/02/2022.
//

import UIKit
import CoreLocation

class HomeCurrenLocationTableViewCell: UITableViewCell {

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
    @IBOutlet weak var viewPermission: UIView!
    @IBOutlet weak var lblPermission: UILabel!
    @IBOutlet weak var btnOpenSetting: UIButton!
    @IBOutlet weak var imvWind: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblLocationName.text = "Current Location"
        lblPermission.text = "Location service not enable"
        btnOpenSetting.setTitle("Change setting", for: .normal)
        btnOpenSetting.setTitle("Change setting", for: .highlighted)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnOpenSetingPressed(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            if let url = URL(string: "app-settings:root=LOCATION_SERVICES") {
                UIApplication.shared.open(url)
            }
        } else {
            if let url = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func billData(_ location: LocationWeatherDataModel?, _ _data: ForecastWeatherDataModel?) {
        if CLLocationManager.locationServicesEnabled() {
            let status = LocationHelper.authorizationStatus
            switch status {
            case .notDetermined:
                viewPermission.isHidden = false
                lblPermission.text = "Confirm use Location serivce to continue"
                btnOpenSetting.isHidden = true
                break
            case .denied, .restricted:
                viewPermission.isHidden = false
                lblPermission.text = "You denied Location service"
                btnOpenSetting.isHidden = false
                break
            default:
                viewPermission.isHidden = true
                break
            }
        } else {
            lblPermission.text = "Location service not enable\nTo use, please access Settings -> Privacy -> Location Services"
            viewPermission.isHidden = false
            btnOpenSetting.isHidden = false
        }
        
        guard let data = _data else {
            lblLocationName.text = "Current Location"
            lblTemp.text = "-"
            lblWind.text = "Wind" + ": -"
            lblHumidity.text = "Humidity" + ": -"
            lblPressure.text = "Pressure" + ": -"
            lblVisibility.text = "Visibility" + ": -"
            lblDewPoint.text = "Dew point" + ": -"
            lblWeatherDesc.text = ""
            imvWeather.image = nil
            lblUV.text = "UV index" + ": -"
            return
        }
        
        imvWind.transform = CGAffineTransform(rotationAngle:  CGFloat(data.current.wind_deg*(Double.pi/180)))
        lblLocationName.text = location?.name.capitalized ?? "Current Location"
        lblTemp.text = String(format: "%.0f°C", data.current.temp.tempK2C)
        lblWind.text = String(format: "%@: %.1fm/s %@", "Wind",data.current.wind_speed, data.current.wind_deg.windDegSymbol)
        lblHumidity.text = "Humidity" + ": \(Int(data.current.humidity))%"
        
        lblPressure.text = "Pressure" + ": \(Int(data.current.pressure))hPa"
        lblVisibility.text = String(format: "%@: %.1fkm", "Visibility" ,data.current.visibility/1000)
        lblDewPoint.text = String(format: "%@: %.0f°C", "Dew point", data.current.dew_point.tempK2C)
        lblUV.text = "UV index" + ": \(data.current.uvi)"
        
        let weather = data.current.weather.first
        lblWeatherDesc.text = weather?.desc.capitalizingFirstLetter()
        
        if let icon = weather?.icon, !icon.isEmpty {
            imvWeather.image = UIImage(named: icon)
        } else {
            imvWeather.image = nil
        }
    }
}
