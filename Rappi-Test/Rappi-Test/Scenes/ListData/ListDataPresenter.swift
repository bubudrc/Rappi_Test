//
//  ListDataPresenter.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

protocol ListDataPresentationLogic {
    func presentItems(response: ListDataModels.List.Response)
    func presentErrorMsg(response: ListDataModels.List.Response)
    
}

class ListDataPresenter: ListDataPresentationLogic {
    
    weak var viewController: ListDataDisplayLogic?
    
    func presentItems(response: ListDataModels.List.Response) {
        
        guard let items = response.result else {
            let viewModel = ListDataModels.List.ViewModel(displayedItems: [ListDataModels.List.ViewModel.DisplayedItem](), errorMessage: "No Data")
            viewController?.displayErrorGettingItems(viewModel: viewModel)
            return
        }
        
        var displayedItems: [ListDataModels.List.ViewModel.DisplayedItem] = []
        for item in items {
        
            let itemID = item.id.description
            let title = item.title ?? item.name ?? item.originalTitle ?? item.originalName ?? ""
            let releaseDate = item.releaseDate ?? ""
            var rate = ""
            if let average = item.voteAverage, average > 0 {
                rate = average.description
            }
            let overview = item.overview ?? ""
            let posterURL = "\(Constants.imageBaseURL)\(item.posterPath ?? "")"
            
            let displayedItem = ListDataModels.List.ViewModel.DisplayedItem(ID: itemID, title: title, releaseDate: releaseDate, rate: rate, overview: overview, posterURL: posterURL)
            
            displayedItems.append(displayedItem)
        }
        
        let viewModel = ListDataModels.List.ViewModel(displayedItems: displayedItems, errorMessage: nil)
        viewController?.displayItems(viewModel: viewModel)
        
    }
    
    func presentErrorMsg(response: ListDataModels.List.Response) {
        let viewModel = ListDataModels.List.ViewModel(displayedItems: [ListDataModels.List.ViewModel.DisplayedItem](), errorMessage: response.errorMessage)
        viewController?.displayErrorGettingItems(viewModel: viewModel)
    }

}
