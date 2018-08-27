//
//  DetailDataModels.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 25/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

enum DetailDataModels {
    
    // MARK: Use cases
    
    enum Detail
    {
        struct Request
        {
            var section: Constants.Sections
            var itemID: String
        }
        struct Response
        {
            var section: Constants.Sections
            var resultMovie: ItemMovieDetail?
            var resultSerie: ItemSerieDetail?
            var errorMessage: String?
        }
        struct ViewModel
        {
            struct DisplayedDetailItem {
                var ID: String
                var title: String
                var posterURL: String
                var detailData: [String]
            }
            
            var displayedItem: DisplayedDetailItem?
            var errorMessage: String?
        }
    }
}
