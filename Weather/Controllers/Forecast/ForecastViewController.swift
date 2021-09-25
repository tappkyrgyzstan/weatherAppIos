//
//  ForecastViewController.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 21/9/21.
//

import UIKit
import MapKit

class ForecastViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private var model: ForecastViewModel?
    private var locationManager = CLLocationManager()
    private let userDefaults = UserDefaults.standard
    
    
    var daily = [Daily]()
    var cityName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = ForecastViewModel()
        model?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ForecastTableViewCell.nib, forCellReuseIdentifier: ForecastTableViewCell.reuseID)
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = .systemTeal
        tableView.backgroundColor = .systemTeal
        configureOfflineData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLocation()
    }
    
    func configureOfflineData() {
        do {
            let data = try userDefaults.getObject(forKey: "lastForecast", castTo: Forecast.self)
            self.cityName = data.timezone ?? ""
            if let daily = data.daily {
                self.daily = daily
            }
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        guard let lng = locationManager.location?.coordinate.longitude else {return}
        guard let lat = locationManager.location?.coordinate.latitude else {return}
        model?.getLocation(lat: lat, lng: lng)
    }
    
    func locationDenied() {
        let alertController = UIAlertController (title: "Provide an access", message: "Please provide an access to use your current location. Go to Settings?", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: {_ in
                    self.getLocation()
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: CLLOCATION MANAGER DELEGATE

extension ForecastViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            getLocation()
        } else if status == .denied {
            locationDenied()
        }
    }
}

extension ForecastViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 16.0, y: 0.0, width: 250, height: 40))
        view.backgroundColor = .systemTeal
        let label = UILabel(frame: CGRect(x: 16.0, y: 0, width: view.frame.width, height: view.frame.height))
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        label.clipsToBounds = true
        label.text = cityName
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daily.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseID, for: indexPath) as! ForecastTableViewCell

        cell.getDailyForecast(list: daily[indexPath.row])

        return cell
    }
}

extension ForecastViewController: ForecastViewModelDelegate {
    func didGetForecast(result: Forecast) {
        cityName = result.timezone ?? ""
        if let daily = result.daily {
            self.daily = daily
        }
        emptyLabel.isHidden = daily.isEmpty ? false : true
        tableView.isHidden = daily.isEmpty ? true : false
        tableView.reloadData()
    }
    
}
