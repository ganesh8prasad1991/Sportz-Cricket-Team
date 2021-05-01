//
//  ApiClient.swift
//  Sportz Cricket Team
//
//  Created by Ganesh Prasad on 30/04/21.
//  Copyright © 2021 Sportz Cricket Team. All rights reserved.
//

import Foundation

public enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}

class ApiClent {
    
    static let shared = ApiClent()
    
    private init() {}
    
    private let urlSession = URLSession.shared
    
    private let baseURL = URL(string: "https://cricket.yahoo.net/sifeeds/cricket/live/json/sapk01222019186652.json")!
//    private let baseURL = URL(string: "https://cricket.yahoo.net/sifeeds/cricket/live/json/sapk01222019186652.json")!
    
    
    func get(completion: @escaping (Result<Response, APIServiceError>) -> Void) {
        
        urlSession.dataTask(with: baseURL) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    if let dict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] {
                        
                        completion(.success(Response(dict: dict)))
                    }
                    
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(_):
                completion(.failure(.apiError))
            }
        }.resume()
    }
}


    

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
