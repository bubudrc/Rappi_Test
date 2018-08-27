//
//  Constants.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

struct App {
    static let shared = App()
    static let infoPath = Bundle.main.path(forResource: "Info", ofType: ".plist")
    let configDictionary = NSDictionary(contentsOfFile: infoPath ?? "")
    
    static func getValueFromInfoPlist(with key: String) -> String {
        guard let dictionary = App.shared.configDictionary,
            let value = dictionary[key] as? String else {
                fatalError("\(key) key plist not found")
        }
        return value
    }
}

struct Constants {
    enum Sections {
        case movies, series
        
        var title: String {
            switch self {
            case .movies: return "Movies"
            case .series: return "Series"
            }
        }
        
        var path: String {
            switch self {
            case .movies: return "movie"
            case .series: return "tv"
            }
        }
    }
    
    enum SortedKind: Int {
        case popular = 0
        case topRated = 1
        case upcoming = 2
        
        var sorted: [String: String] {
            switch self {
            case .popular: return ["sort_by": "popularity.desc"]
            case .topRated: return ["sort_by": "vote_average.desc"]
            case .upcoming: return ["sort_by": "primary_release_date.ask"]
            }
        }
    }
    
    static let baseURL = App.getValueFromInfoPlist(with: "BaseURLKey")
    static let autorizationToken = App.getValueFromInfoPlist(with: "AuthorizationToken")
    static let apiKey = App.getValueFromInfoPlist(with: "APIKey")
    static let imageBaseURL = "https://image.tmdb.org/t/p/w154"
    
    static let defaultHeadersRequests = [
        "Accept": "application/json",
        "Content-Type" :"application/json;charset=utf-8",
        "Authorization" : "Bearer \(autorizationToken)"
    ]
}
