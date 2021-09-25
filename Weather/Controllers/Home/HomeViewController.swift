//
//  HomeViewController.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 21/9/21.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperature1: UILabel!
    @IBOutlet weak var temperature2: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    

    private var lat: Double?
    private var lng: Double?
    private var model: HomeViewModel?
    private var locationManager = CLLocationManager()
    private let userDefaults = UserDefaults.standard
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = HomeViewModel()
        model?.delegate = self
        configureSearchBar()
        hideKeyboardWhenTappedAround()
        confifureLastData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getLocation()
    }
    
//MARK: OFFLINE HANDLE
    
    func confifureLastData() {
        do {
            let data = try userDefaults.getObject(forKey: "lastResult", castTo: GeneralModel.self)
            cityLabel.text = data.name ?? ""
            if let weather = data.weather {
                for text in weather {
                    descriptionLabel.text = text.description?.capitalized
                }
            }
            temperatureLabel.text = "\(round(data.main?.temp ?? 0.0))°"
            temperature1.text = "\(data.main?.temp_min ?? 0.0)℃"
            temperature2.text = "\(data.main?.temp_min ?? 0.0)℃"
            feelsLikeLabel.text = "\(data.main?.feels_like ?? 0.0)℃"
            windLabel.text = "\(data.wind?.speed ?? 0.0) m/s"
            humidityLabel.text = "\(data.main?.humidity ?? 0)%"
            pressureLabel.text = "\(data.main?.pressure ?? 0)hPa"
            visibilityLabel.text = "\(data.visibility ?? 0) m"
            cloudsLabel.text = "\(data.clouds?.all ?? 0)%"
        } catch {
            print(error.localizedDescription)
        }
    }
    
//MARK: LOCATION HANDLE
        
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        guard let lng = locationManager.location?.coordinate.longitude else {return}
        guard let lat = locationManager.location?.coordinate.latitude else {return}
        model?.getDataByLocation(lat: lat, lng: lng)
    }
    
//MARK: SEARCH HANDLE
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Moscow"
        searchBar.tintColor = .systemTeal
        searchBar.backgroundColor = .systemTeal
    
    }

//MARK: LOCATION DENIED HANDLE
    
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

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            getLocation()
        } else if status == .denied {
            locationDenied()
        }
    }
}

//MARK: UISEARCH BAR DELEGATE

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        model?.getDataByCityName(cityName: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}

//MARK: NETWORK RESULT DELEGATE

extension HomeViewController: HomeViewModelDelegate {
    func didGetData(result: GeneralModel) {
        cityLabel.text = result.name ?? ""
        if let weather = result.weather {
            for text in weather {
                descriptionLabel.text = text.description?.capitalized
            }
        }
        temperatureLabel.text = "\(round(result.main?.temp ?? 0.0))°"
        temperature1.text = "\(result.main?.temp_min ?? 0.0)℃"
        temperature2.text = "\(result.main?.temp_min ?? 0.0)℃"
        feelsLikeLabel.text = "\(result.main?.feels_like ?? 0.0)℃"
        windLabel.text = "\(result.wind?.speed ?? 0.0) m/s"
        humidityLabel.text = "\(result.main?.humidity ?? 0)%"
        pressureLabel.text = "\(result.main?.pressure ?? 0)hPa"
        visibilityLabel.text = "\(result.visibility ?? 0) m"
        cloudsLabel.text = "\(result.clouds?.all ?? 0)%"
        if let icon = result.weather {
            for i in icon {
                let img = i.icon ?? ""
                let urlStr = NSURL(string: "http://openweathermap.org/img/wn/\(img).png")
                if let url = urlStr {
                    let urlData = NSData(contentsOf: url as URL)
                    if urlData != nil {
                        self.icon.image = UIImage(data: urlData! as Data)
                    }
                }
            }
        }
    }
}
