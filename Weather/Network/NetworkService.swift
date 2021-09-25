//
//  NetworkService.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 24/9/21.
//

import Foundation

class NetworkService: NSObject {
    private var logger = Logger()
    
    var session: URLSession {
        return URLSession(configuration: .default)
    }
    
    var dataTask: URLSessionDataTask?
    
    func performRequest<T : Codable> (route: NetworkRoute, completion: @escaping (Result<T?, Error>) -> Void) {
        
        var components = URLComponents()
        components.scheme = route.schema.rawValue
        components.host = route.host.rawValue
        components.path = route.path
        components.queryItems = route.parameters

        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = route.httpMethod.rawValue
        
        logger.log(request: request)
        dataTask = session.dataTask(with: request) { (data, response, error) in
            self.logger.log(data: data, response: response as? HTTPURLResponse, error: error)
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            
            guard let data = data, response != nil else {
                return
            }
    
            let responseObject = try? JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(.success(responseObject))
            }
        }
        dataTask?.resume()
    }
}
