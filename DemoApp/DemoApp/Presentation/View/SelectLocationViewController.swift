//
//  SearchLocationViewController.swift
//  WindyDemo2
//
//  Created by Đào Mỹ Đông on 25/02/2022.
//

import UIKit
import SwiftyJSON

class SelectLocationViewController: BaseViewController {

    @IBOutlet weak var txfSearch: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var tbvMain: UITableView!
    @IBOutlet weak var lblNoResult: UILabel!
    var locationIds: [String] = []
    private let locationDataManager = LocationDataManager()
    private var listResult: [LocationModel] = []
    fileprivate var selectLocationHandler: ((_ location: LocationModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        txfSearch.becomeFirstResponder()
        doSearch("")
    }

    //MARK:- IBACIONS
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- METHODS
    private func setupView() {
        lblNoResult.isHidden = true
    }
    
    private func doSearch(_ str: String) {
        locationDataManager.doSearchLocation(name: str) { [weak self] (list: [LocationModel]) in
            DispatchQueue.main.async {
                self?.listResult = list
                self?.tbvMain.reloadData()
                self?.lblNoResult.isHidden = str.isEmpty ? true : !list.isEmpty
            }
        }
    }
    
    deinit {
        selectLocationHandler = nil
    }
}

extension SelectLocationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = listResult[indexPath.row]
        let cell = LocationResultTableViewCell.dequeCellWithTable(tableView)
        cell.lblTitle.text = item.name.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listResult[indexPath.row]
        selectLocationHandler?(item)
        selectLocationHandler = nil
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectLocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            doSearch(updatedText)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doSearch(textField.text ?? "")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doSearch(textField.text ?? "")
        return true
    }
}

extension SelectLocationViewController {
    class func doSelectLocation(from: UIViewController,
                                selectedLocationIds: [String],
                                selectedHandle: ((_ location: LocationModel) -> Void)?) {
        let vc = SelectLocationViewController.initWithDefaultNib()
        vc.selectLocationHandler = selectedHandle
        from.present(vc, animated: true, completion: nil)
    }
}
