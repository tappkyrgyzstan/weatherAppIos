//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 25/9/21.
//

import Foundation

protocol ForecastViewModelDelegate: AnyObject {
    func didGetForecast(result: Forecast)
}

class ForecastViewModel: NSObject {
    weak var delegate: ForecastViewModelDelegate?
    private let service = NetworkService()
    private let appid = "666d2b8cb2e634b2d37b6b1ec0317665"
    private let unit = "metric"
    private var excludeArray = ["current", "minutely", "hourly", "alerts"]
    private let userDefaults = UserDefaults.standard
    
    
    func getLocation(lat: Double, lng: Double) {
        let exclude = excludeArray.map{($0.description)}.joined(separator: ",")
        service.performRequest(route: .getForecast(lat, lng, exclude, unit, appid)) { (result: Result<Forecast?, Error>) in
            switch result {
            case .success(let object):
                if let obj = object {
                    self.delegate?.didGetForecast(result: obj)
                    do {
                        try self.userDefaults.setObject(obj, forKey: "lastForecast")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print("SHOW ALERT: \(error.localizedDescription)")
            }
        }
    }
}
