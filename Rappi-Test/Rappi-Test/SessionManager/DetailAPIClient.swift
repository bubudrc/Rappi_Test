//
//  DetailAPIClient.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 25/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

// MARK: - API extension

extension APIClient {
    
    /// Retrieves the top messages
    ///
    /// - parameter itemID:       The item identifier
    /// - parameter section:      The kind of list (Movies or Series)
    /// - parameter callback:     The service path.
    func getDetailItem(ofItemID itemID: String, fromSection section: Constants.Sections = .movies, andCallBack callback: @escaping (Any?, Error?) -> Void){
        
        let requestPath = "3/\(section.path)/\(itemID)"
        let queryString = ["api_key": Constants.apiKey, "language":"en-US"]
        
        APIClient.sharedInstance.executeRequest(path:requestPath,
                                                queryString: APIClient.queryString(fromParameters: queryString), headers: nil) { (responseRequest, error) in
                                                    
                                                    if let data = responseRequest {
                                                        do {
                                                            if section == .movies {
                                                                let result = try JSONDecoder().decode(ItemMovieDetail.self, from: data)
                                                                callback(result, nil)
                                                            } else {
                                                                let result = try JSONDecoder().decode(ItemSerieDetail.self, from: data)
                                                                callback(result, nil)
                                                            }
                                                        } catch {
                                                            callback(nil, error)
                                                        }
                                                    } else {
                                                        let error = NSError.error(domain: APIClientErrorDomain,
                                                                                  code: APIClientErrorUnsuccessfulRequest,
                                                                                  description: "Unsuccessful parse data")
                                                        callback(nil, error)
                                                    }
        }
    }
}
