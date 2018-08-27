//
//  DetailDataInteractor.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 25/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

protocol DetailDataBusinessLogic {
    func getDetailOfItem(request: DetailDataModels.Detail.Request)
}

class DetailDataInteractor: DetailDataBusinessLogic {
    
    var presenter: DetailDataPresentationLogic?
    
    let detailDataWorker: DataWorkerProtocol = DataWorker()
    
    func getDetailOfItem(request: DetailDataModels.Detail.Request) {
        detailDataWorker.getDetailItem(ofItemID: request.itemID, fromSection: request.section) { [weak self] (result, error) in
            
            if let `self` = self, let presenter = `self`.presenter {
            
                guard let responseData = result else {
                    let response = DetailDataModels.Detail.Response(section: request.section, resultMovie: nil, resultSerie: nil, errorMessage: "Error Parsing data")
                    presenter.presentErrorMsg(response: response)
                    return

                }

                let response = DetailDataModels.Detail.Response(section: request.section, resultMovie: request.section == .movies ? responseData as? ItemMovieDetail : nil, resultSerie: request.section == .series ? responseData as? ItemSerieDetail : nil, errorMessage: nil)
                presenter.presentItemDetail(response: response)
            }
        }
    }

}
