//
//  ListDataWorker.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

protocol DataWorkerProtocol: class {
    func getAllItems(fromSection section: Constants.Sections, sortedBy: Constants.SortedKind, withQueries query: [String: String]?, andCallBack callback: @escaping (Any, Error?) -> Void)
    
    func getDetailItem(ofItemID itemID: String, fromSection section: Constants.Sections, andCallBack callback: @escaping (Any?, Error?) -> Void)
}

class DataWorker: DataWorkerProtocol {
    
    func getAllItems(fromSection section: Constants.Sections, sortedBy: Constants.SortedKind, withQueries query: [String: String]?, andCallBack callback: @escaping (Any, Error?) -> Void) {
        APIClient.sharedInstance.getAllItems(fromSection: section, sortedBy: sortedBy, withQueries: query) { (result, error) in
            
            guard let responseRequest = result, error == nil else {
                callback([Item](), error)
                return
            }
            
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(responseRequest) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "\(section.title)-\(sortedBy.rawValue.description)")
            }
        
            
            callback(responseRequest.results, error)
        }
    }
    
    func getDetailItem(ofItemID itemID: String, fromSection section: Constants.Sections, andCallBack callback: @escaping (Any?, Error?) -> Void) {
        APIClient.sharedInstance.getDetailItem(ofItemID: itemID, fromSection: section) { (result, error) in
            guard let responseRequest = result, error == nil else {
                callback(nil, error)
                return
            }
            
            
            let encoder = JSONEncoder()
            let key = "\(section.title)-\(itemID.description)"
            
            if let requestMovie = responseRequest as? ItemMovieDetail, let encoded = try? encoder.encode(requestMovie) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: key)
            } else if let requestMovie = responseRequest as? ItemSerieDetail, let encoded = try? encoder.encode(requestMovie) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: key)
            }
            
           callback(responseRequest, error)
        }
    }
}
