//
//  APIClient.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

let APIClientErrorDomain = "APIClientErrorDomain"
let APIClientErrorUnsuccessfulRequest   = 500
let APIClientErrorParseError            = 501

class APIClient: NSObject {
    static let baseURLPath = Constants.baseURL
    
    enum HTTPMethod: String {
        case get    = "GET"
        case post   = "POST"
    }
    
    /// Singleton instance
    static let sharedInstance = APIClient()
    
    /// Sends a request to the server
    ///
    /// - parameter method:         The HTTP method. `GET` by default.
    /// - parameter baseURL:        API base URL.
    /// - parameter path:           The service path.
    /// - parameter queryString:    URL query portien. `nil` by default.
    /// - parameter parameters:     The body parameters. Empty dictionary by default.
    /// - parameter callback        Callback called once the server responds.
    func executeRequest(method:HTTPMethod = .get,
                        baseURL:String = baseURLPath,
                        path:String,
                        queryString:String = "",
                        parameters: [String:Any] = [:],
                        headers: [String: String]?,
                        callback:@escaping(_ result: Data?,_ error: Error?) -> Void){
        
        var urlRequest = URLRequest(url: URL(string:baseURL + path + queryString)!)
        
        urlRequest.httpMethod = method.rawValue
        
        if let allHeaders = headers {
            for (key, value) in allHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = defaultSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
            if let requestError = error {
                callback(nil, requestError)
            } else {
                
                let response = urlResponse as! HTTPURLResponse
                
                if response.statusCode == 200 {
                    
                    
                    
                    if let data = data {
                        
//                        do {
//                            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
//                            if let theJSONData = try? JSONSerialization.data(
//                                withJSONObject: dictionary,
//                                options: []) {
//                                let theJSONText = String(data: theJSONData,
//                                                         encoding: .ascii)
//                                print("JSON string = \(theJSONText!)")
//                                
//                            }
//                        } catch {
//                            
//                            print("LLEGA AL CATCH?")
//                            
//                        }
                    
                        callback(data, nil)
                    } else {
                        let error = NSError.error(domain: APIClientErrorDomain,
                                                  code: APIClientErrorUnsuccessfulRequest,
                                                  description: "No Data")
                        callback(nil, error)
                    }
                }  else {

                    let error = NSError.error(domain: APIClientErrorDomain,
                                              code: APIClientErrorUnsuccessfulRequest,
                                              description: "Unsuccessful Request status code: \(response.statusCode)")
                    callback(nil, error)
                }
            }
        }
        
        dataTask.resume()
    }
    
    /// Creates a query string from a dictionary
    ///
    /// - parameter fromParameters: The dictionary.
    static func queryString(fromParameters:[String:Any]) -> String {
        guard fromParameters.count > 0 else { return "" }
        
        var parameterString = ""
        for (key, value) in fromParameters {
            if parameterString.count > 0  {
                parameterString.append("&")
            }
            parameterString.append(key + "=" + (value is Int ? String(describing: value) : value as! String))
        }
        return "?" + parameterString
    }
}



