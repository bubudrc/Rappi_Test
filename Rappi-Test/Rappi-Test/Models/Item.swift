//
//  Item.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import Foundation

struct ResponseRequest: Codable {
    let totalPages: Int
    let results: [Item]
    let totalResults, page: Int
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
        case totalResults = "total_results"
        case page
    }
}

struct Item: Codable {
    var id: Int
    var voteAverage: Double?
    var genreIDS: [Int]
    var popularity: Double
    var posterPath, title, overview, name, originalTitle, originalName, releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, popularity
        case voteAverage = "vote_average"
        case genreIDS = "genre_ids"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case title, overview, name
        case releaseDate = "release_date"
        case originalName = "original_name"
    }
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let voteAverageInt = try? container.decode(Int.self, forKey: .voteAverage)
        let voteAverageDouble = try? container.decode(Double.self, forKey: .voteAverage)

        let genreIDS = try container.decode([Int].self, forKey: .genreIDS)
        let name = try? container.decode(String.self, forKey: .name)
        let originalTitleMovie = try? container.decode(String.self, forKey: .originalTitle)
        let originalNameSerie = try? container.decode(String.self, forKey: .originalName)
        let popularity = try container.decode(Double.self, forKey: .popularity)
        let posterPath = try? container.decode(String.self, forKey: .posterPath)
        let title = try? container.decode(String.self, forKey: .title)
        let overview = try? container.decode(String.self, forKey: .overview)
        let releaseDate = try? container.decode(String.self, forKey: .releaseDate)
        
        self.id = id
        self.name = name ?? ""
        self.voteAverage = voteAverageDouble ?? Double(voteAverageInt ?? 0)
        self.genreIDS = genreIDS
        self.originalTitle = originalTitleMovie ?? ""
        self.originalName = originalNameSerie ?? ""
        self.popularity = popularity
        self.posterPath = posterPath
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
    }
}
