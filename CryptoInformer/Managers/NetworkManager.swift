//
//  NetworkManager.swift
//  CryptoInformer
//
//  Created by Artyom Beldeiko on 19.10.22.
//

import Foundation

struct ManagerConstants {
    static let baseURL = "http://api.coinlayer.com/api/live?access_key="
    static let key = "cb5376e094f3e811f6f0e8df4219fe0b" 
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getRates(completion: @escaping (Result<Rate, Error>) -> Void) {
        guard let url = URL(string: "\(ManagerConstants.baseURL)\(ManagerConstants.key)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(Rate.self, from: data)
                completion(.success(results.self))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
}
