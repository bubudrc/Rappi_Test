//
//  ListDataRouter.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit


protocol ListDataRoutingLogic {
    func routeToItemDetail(withItem item: ListDataModels.List.ViewModel.DisplayedItem, forSection section: Constants.Sections)
}

class ListDataRouter: NSObject, ListDataRoutingLogic {
    
    weak var viewController: ListDataViewController?
    
    func routeToItemDetail(withItem item: ListDataModels.List.ViewModel.DisplayedItem, forSection section: Constants.Sections) {
        if let detailItemVC = DetailDataViewController.create() as? DetailDataViewController {
            detailItemVC.sectionType = section
            
            let detailData = DetailDataModels.Detail.ViewModel.DisplayedDetailItem(ID: item.ID, title: item.title, posterURL: item.posterURL, detailData: [])
            detailItemVC.itemDetail = detailData
            
            viewController?.navigationController?.pushViewController(detailItemVC, animated: true)
        }
    }
    
    
}
