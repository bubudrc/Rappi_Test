//
//  ListDataInteractor.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

protocol ListDataBusinessLogic {
    func getListOfItems(request: ListDataModels.List.Request)
    
}

class ListDataInteractor: ListDataBusinessLogic {
    
    var presenter: ListDataPresentationLogic?
    
    let listDataWorker: DataWorkerProtocol = DataWorker()
    
    func getListOfItems(request: ListDataModels.List.Request) {
        listDataWorker.getAllItems(fromSection: request.section, sortedBy: request.sortedBy, withQueries: request.queries) { [weak self] (result, error) in
            
            if let `self` = self, let presenter = `self`.presenter {
                guard let responseData = result as? [Item] else {
                    let response = ListDataModels.List.Response(result: nil, errorMessage: error.debugDescription)
                    presenter.presentErrorMsg(response: response)
                    return
                    
                }
                
                let response = ListDataModels.List.Response(result: responseData, errorMessage: nil)
                presenter.presentItems(response: response)
            }
        }
    }
}
