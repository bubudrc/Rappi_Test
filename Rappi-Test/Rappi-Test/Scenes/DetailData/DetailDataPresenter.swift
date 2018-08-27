//
//  DetailDataPresenter.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 25/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

protocol DetailDataPresentationLogic {
    func presentItemDetail(response: DetailDataModels.Detail.Response)
    func presentErrorMsg(response: DetailDataModels.Detail.Response)
}

class DetailDataPresenter: DetailDataPresentationLogic {
    weak var viewController: DetailDataDisplayLogic?
    
    func presentItemDetail(response: DetailDataModels.Detail.Response) {
        
        guard response.errorMessage == nil else {
            let viewModel = DetailDataModels.Detail.ViewModel(displayedItem: nil, errorMessage: response.errorMessage)
            viewController?.displayErrorGettingItems(viewModel: viewModel)
            return
        }
        
        var viewModel = DetailDataModels.Detail.ViewModel(displayedItem: nil, errorMessage: nil)
        
        if response.section == .movies {
            guard let movieData = response.resultMovie else {return}
            
            let itemID = movieData.id.description
            let title = movieData.title
            let posterURL = "\(Constants.imageBaseURL)\(movieData.posterPath)"
            
            let tagLine = "TAGLINE:\n \(movieData.tagline)"
            let overview = "OVERVIEW:\n \(movieData.overview)"
            let releaseData = "RELEASE DATE:\n \(movieData.releaseDate)"
            let budget = "BUDGET:\n \(movieData.budget.description)"
            let revenue = "REVENUE:\n \(movieData.revenue.description)"
            let dataGenres = movieData.genres.map{$0.name}
            let genres = "GENRES:\n \(dataGenres.joined(separator: ", "))"
            let homePage = "HOMEPAGE:\n \(movieData.homepage)"
            
            
            let itemsData: [String] = [tagLine, overview, releaseData, budget, revenue, genres, homePage]

            let viewModelItem = DetailDataModels.Detail.ViewModel.DisplayedDetailItem(ID: itemID, title: title, posterURL: posterURL, detailData: itemsData)
            
            viewModel.displayedItem = viewModelItem
            
        } else {
            
            guard let serieData = response.resultSerie else {return}
            
            let itemID = serieData.id.description
            let title = serieData.name
            let posterURL = "\(Constants.imageBaseURL)\(serieData.posterPath)"
            
            let overview = "OVERVIEW:\n \(serieData.overview)"
            let dataSeasons = serieData.seasons.map{ "Season \($0.seasonNumber.description): \($0.name)" }
            let seasons = "SEASONS:\n \(dataSeasons.joined(separator: "\n"))"
            let episodes = "EPISODES:\n \(serieData.numberOfEpisodes.description)"
            let creatorsData = serieData.createdBy.map{$0.name}
            let creators = "\(serieData.createdBy.count > 1 ? "CREATORS" : "CREATOR"):\n \(creatorsData.joined(separator: ", "))"
            let dataGenres = serieData.genres.map{$0.name}
            let genres = "GENRES:\n \(dataGenres.joined(separator: ", "))"
            let homePage = "HOMEPAGE:\n \(serieData.homepage)"
            
            
            let itemsData: [String] = [overview, seasons, episodes, creators, genres, homePage]
            
            let viewModelItem = DetailDataModels.Detail.ViewModel.DisplayedDetailItem(ID: itemID, title: title, posterURL: posterURL, detailData: itemsData)
            
            viewModel.displayedItem = viewModelItem
        }
        
        viewController?.displayItem(viewModel: viewModel)
    }
    
    func presentErrorMsg(response: DetailDataModels.Detail.Response) {
        let viewModel = DetailDataModels.Detail.ViewModel(displayedItem: nil, errorMessage: response.errorMessage)
        viewController?.displayErrorGettingItems(viewModel: viewModel)
    }

}
