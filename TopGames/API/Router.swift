//
//  Router.swift
//  TopGames
//
//  Created by Matheus Weber on 10/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum ApiError: Error {
    case wrongUrl(String)
}

enum Result<Value> {
    case success(Value)
    case error(Error)
}

typealias anyDict = [String: Any]
typealias successErrorComplition = (Bool, String?) -> Void
typealias successComplition = (Bool) -> Void

class RouterService {
    
    let sessionManager = SessionManager()
    
    static let sharedInstance = RouterService()
    
    enum Router: URLRequestConvertible {
        case getTopGames(limit: Int, offset: Int)
        
        func asURLRequest() throws -> URLRequest {
            
            let (verb, path, parameters): (String, String, [String: Any]?) = {
                switch self {
                case .getTopGames(let limit, let offset):
                    return ("GET", "\(Endpoints.urlEndpoint(.Games))/top?limit=\(limit)&offset=\(offset)", nil)
                }
            }()
            
            var urlRequest = URLRequest(url: URL(string: path)!)
            
            urlRequest.httpMethod = verb
            urlRequest.setValue(Endpoints.clientId, forHTTPHeaderField: "Client-ID")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            urlRequest.timeoutInterval = 60.0
            
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        }
    }
    
    func FetchTopGames(with limit: Int, and offset: Int, _ callback: @escaping ((Result<Any>) -> Void)) {
            requestWithData(Router.getTopGames(limit: limit, offset: offset)) { ( result: Result<Data>) in
                switch(result) {
                case .success(let resultModel):
                    do {
                        let decoder = JSONDecoder()
                        let results = try decoder.decode(ResultModel.self, from: resultModel)
                        callback(.success(results.top))
                    } catch let err {
                        callback(.error(err))
                    }
                case .error(let error):
                    callback(.error(error))
                }
            }
    }
    
    //MARK: Core

    func requestWithData(_ requestURL:URLRequestConvertible,  callback: @escaping (Result<Data>) -> Void) {
       sessionManager.request(requestURL)
            .validate()
            .responseData() { response in
                switch response.result {
                case .success (let result):
                    callback(.success(result))
                case .failure(let error):
                    callback(.error(error))
                }
        }
    }
}
