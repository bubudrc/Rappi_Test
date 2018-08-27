//
//  ListDataModels.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

enum ListDataModels {
    
    // MARK: Use cases
    
    enum List
    {
        struct Request
        {
            var section: Constants.Sections
            var sortedBy: Constants.SortedKind
            var queries: [String: String]?
        }
        struct Response
        {
            var result: [Item]?
            var errorMessage: String?
        }
        struct ViewModel
        {
            struct DisplayedItem {
                var ID: String
                var title: String
                var releaseDate: String
                var rate: String
                var overview: String
                var posterURL: String
            }
            
            var displayedItems: [DisplayedItem]
            var errorMessage: String?
        }
    }
}
