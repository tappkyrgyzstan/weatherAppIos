//
//  HomeViewModel.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 24/9/21.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didGetData(result: GeneralModel)
}

class HomeViewModel: NSObject {
    
    weak var delegate: HomeViewModelDelegate?
    private var service = NetworkService()
    private let userDefaults = UserDefaults.standard
 
    private let key = "666d2b8cb2e634b2d37b6b1ec0317665"
    private let unit = "metric"

    func getDataByLocation(lat: Double, lng: Double) {
        service.performRequest(route: .byLocation(lng, lat, key, unit)) { (result: Result<GeneralModel?, Error>) in
            switch result {
            case .success(let obj):
                if let result = obj {
                    self.delegate?.didGetData(result: result)
                    do {
                        try self.userDefaults.setObject(result, forKey: "lastResult")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print("SHOW ALERT: \(error.localizedDescription)")
            }
        }
    }
    
    func getDataByCityName(cityName: String) {
        service.performRequest(route: .byCityName(cityName, key, unit)) { (result: Result<GeneralModel?, Error>) in
            switch result {
            case .success(let obj):
                if let result = obj {
                    self.delegate?.didGetData(result: result)
                }
            case .failure(let error):
                print("SHOW ALERT: \(error.localizedDescription)")
            }
        }
    }
}
