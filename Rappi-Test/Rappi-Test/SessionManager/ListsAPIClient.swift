//
//  ListsAPIClient.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

// MARK: - API extension

extension APIClient {
    
    /// Retrieves the top messages
    ///
    /// - parameter section:      The kind of list (Movies or Series)
    /// - parameter sorted:       The kind of sorted (Popular, Top Rated, Upcoming)
    /// - parameter query:        The extra query
    /// - parameter callback:     The service path.
    func getAllItems(fromSection section: Constants.Sections = .movies, sortedBy: Constants.SortedKind = .popular, withQueries query: [String: String]? = nil, andCallBack callback: @escaping (ResponseRequest?, Error?) -> Void){
        
        let requestPath = "4/discover/\(section.path)"
        let headersDic = Constants.defaultHeadersRequests
        var queryString = sortedBy.sorted
        
        if let queryData = query {
            for key in queryData.keys {
                queryString[key] = queryData[key]
            }
        }
        
        APIClient.sharedInstance.executeRequest(path:requestPath,
                                                queryString: APIClient.queryString(fromParameters: queryString), headers: headersDic) { (responseRequest, error) in
                                                    
                                                    if let data = responseRequest {
                                                        do {
                                                            let result = try JSONDecoder().decode(ResponseRequest.self, from: data)
                                                            callback(result, nil)
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
