//
//  Router.swift
//  Swish
//
//  Created by Matheus Weber on 24/08/16.
//  Copyright © 2016 Matheus Weber. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum ApiError: Error {
    case WrongUrl(String)
}

enum Result<Value> {
    case Success(Value)
    case Error(ApiError)
}

typealias anyDict = [String: Any]
typealias successErrorComplition = (Bool, String?) -> Void
typealias successComplition = (Bool) -> Void

class RouterService {
    
    let sessionManager = SessionManager()
    
    static let sharedInstance = RouterService()
    
    enum Router: URLRequestConvertible {
        case getTopGames(page: Int)
        
        func asURLRequest() throws -> URLRequest {
            
            let (verb, path, parameters): (String, String, [String: Any]?) = {
                switch self {
                case .getTopGames(_):
                    return ("GET", "\(Endpoints.urlEndpoint(.Games))/top", nil)
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
    
    func FetchTopGames(page: Int, _ callback: @escaping ((Result<[GameModel]>) -> Void)) {
            requestWithJSON(Router.getTopGames(page: page), resultKey: "items") { ( jsonData: [anyDict]?, error) in
    
//                var repositoryList = [RepositoryModel]()
//
//                if jsonData != nil {
//
//                    for repository in jsonData! {
//                        repositoryList.append(RepositoryModel(jsonData: repository))
//                    }
//                }
//
//                callback(repositoryList)
            }
    }
    
    //MARK: Core
    
    func requestWithSuccess(_ request: URLRequestConvertible, callback: @escaping successComplition ) {
        requestWithSuccessJSON(request) { ( success, error) in
            return success != nil ? callback(true) : callback(false)
        }
    }
    
    func requestWithSuccessError(_ request: URLRequestConvertible, callback: @escaping successErrorComplition ) {
        requestWithSuccessJSON(request) { ( success, error) in
            if success != nil {
               // print(message)
                callback(true, nil)
            } else {
                //print(error)
                callback(false, error!)
            }
        }
    }
    
    func requestWithJSON<T>(_ requestURL:URLRequestConvertible, resultKey: String = "data",  callback: @escaping (T?, String? ) -> Void) {
        sessionManager.request(requestURL)
            .validate()
            .responseJSON() { response in
                //print(requestURL.urlRequest)
                //print(response)
                //print(response.result)
                //print(response.result.value)
                switch response.result {
                    
                case .success (_):
                    if !resultKey.isEmpty{
                        guard let validJSON = response.result.value as? [String: Any], let validData = validJSON[resultKey] as? T else {
                            
                            print("Error while fetching")
                            callback(nil, "Not Found Data")
                            return
                        }
                        callback(validData, nil)
                    }else{
                        if let validJSON = response.result.value as? T{
                            callback(validJSON, nil)
                        }
                    }
                    
                    
                case .failure(_):
                    do {
                        if let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any], let error = parsedData["error"] as? String  {
                            callback(nil, error)
                        } else {
                            callback(nil, "Error while fetching data")
                        }
                        
                    } catch {
                        callback(nil, "Error while connecting to Swish. Please try again")
                    }
                    break
                }
        }
    }
    
    func requestWithSuccessJSON(_ requestURL:URLRequestConvertible, callback: @escaping (String?, String?) -> Void) {
        sessionManager.request(requestURL)
            .validate()
            .responseJSON() { response in
                
                switch response.result {
                    
                case .success (_):
                    guard let validJSON = response.result.value as? [String: Any], let success = validJSON["success"] as? String  else {
                        callback(nil,  "Error while parsing data")
                        return
                    }
                    callback(success,  nil)
                case .failure(_):
                    
                    do {
                        if let parsedData = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any], let error = parsedData["error"] as? String  {
                            callback(nil, error)
                        } else {
                            callback(nil, "Error while fetching data")
                        }
                        
                    } catch {
                        callback(nil, "Error while connecting to Swish. Please try again")
                    }
                    
                    break
                }
        }
    }
    
}
