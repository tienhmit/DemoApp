//
//  WeatherHomePageView.swift
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class WeatherHomePageView: BaseViewController {
    var presenter = WeatherHomePagePresenter.shared
    
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var tbvMain: UITableView?
    @IBOutlet weak var viewAddLocation: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblUpdate: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        reloadView()
        presenter.weatherHomePageDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidAppear()
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        presenter.selectLocationAction(self)
    }
    
    func setUpView() {
        tbvMain?.tableFooterView = viewAddLocation
        tbvMain?.kAddPullToRefreshCustom { [weak self] in
            self?.presenter.doPullToRefresh()
        }
    }
}

extension WeatherHomePageView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        let count = presenter.listLocationCount
        return count == 0 ? 1 : count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = HomeCurrenLocationTableViewCell.dequeCellWithTable(tableView)
            cell.billData(presenter.currentLocationWeatherData, presenter.getCurrentLocationForecastWeatherData())
            return cell
        }
        
        if presenter.listFavorite.isEmpty {
            let cell = NoDataTableViewCell.dequeCellWithTable(tableView)
            return cell
        }

        let cell = HomeLocationTableViewCell.dequeCellWithTable(tableView)
        let location = presenter.getLocation(index: indexPath.row)
        let forecastData = presenter.getLocationForecastData(index: indexPath.row)
        cell.billData(location, forecastData)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = presenter.listLocationCount
        return indexPath.section == 0 ? 220.0 : (count == 0 ? 300.0 : 50.0)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            presenter.doViewCurrentLocationDetail(self)
        } else if indexPath.section == 1 && presenter.listLocationCount > 0 {
            presenter.doSelectLocation(with: indexPath.row, by: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension WeatherHomePageView: WeatherHomePageDelegate {
    func reloadView() {
        lblTitle?.text = presenter.title
        lblUpdate?.text = presenter.lastTimeString
        tbvMain?.kPullToRefreshStopAnimation()
        tbvMain?.reloadData()
    }
}

extension WeatherHomePageView: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        return true
    }

    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {

        if direction == MGSwipeDirection.rightToLeft {
            weak var weakSelf = self
            let delete = MGSwipeButton(title: LocalizationStringHelper.remove,
                                     icon: nil,
                                     backgroundColor: #colorLiteral(red: 0.9294117647, green: 0.3019607843, blue: 0.2392156863, alpha: 1),
                                     padding: 18)
            { (item: MGSwipeTableCell) -> Bool in
                if let indexPath = weakSelf?.tbvMain?.indexPath(for: cell) {
                    weakSelf?.doRemoveFavorite(indexPath)
                }
                return true
            }

            return [delete]
        }

        return []
    }

    func doRemoveFavorite(_ indexPath: IndexPath) {
        guard let location = presenter.getLocation(index: indexPath.row) else {
            return
        }

        let alert = UIAlertController(title: "Remove" + " \(location.name)",
                                      message: "Do you want remove from favorite list?",
                                      preferredStyle: .alert)
        let actionRemove = UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            self?.presenter.doRemoveLocationFromFavoriteList(location)
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionRemove)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
}
