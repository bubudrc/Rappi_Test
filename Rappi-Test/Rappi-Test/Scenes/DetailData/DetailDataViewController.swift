//
//  DetailDataViewController.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 25/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

protocol DetailDataDisplayLogic: class {
    func displayItem(viewModel: DetailDataModels.Detail.ViewModel)
    func displayErrorGettingItems(viewModel: DetailDataModels.Detail.ViewModel)
}

class DetailDataViewController: UIViewController {
    
    let cellIdentifier = "detailItemTableCellIdentifier"
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var sectionType: Constants.Sections = .movies
    
    private var loadingView = UIView()
    
    var itemDetail: DetailDataModels.Detail.ViewModel.DisplayedDetailItem?
    
    var dataDetails: [String] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return }
                `self`.tableView.reloadData()
            }
        }
    }

    
    var interactor: DetailDataInteractor?
    var router: DetailDataRouter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let itemDetail = itemDetail else {return}
        
        title = itemDetail.title
        
        tableView.estimatedRowHeight = 132.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {return }
            `self`.posterImage.downloadedFrom(link: itemDetail.posterURL)
            `self`.titleLabel.text = itemDetail.title
            `self`.dataDetails = itemDetail.detailData
        }
        
        loadingView = createSpinner()
        setup()
        getItemDetail()
    }
    
    
    //MARK: Private
    func setup(){
        let interactor = DetailDataInteractor()
        let presenter = DetailDataPresenter()
        let router = DetailDataRouter()
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        self.interactor = interactor
        self.router = router
    }
}

extension DetailDataViewController {
    fileprivate func getItemDetail() {
        showOrHideSpinner(spinner: loadingView, mustHideSpinner: false)
        guard let interactor = self.interactor else { return }

        
        if let savedItem = UserDefaults.standard.object(forKey: "\(sectionType.title)-\(itemDetail?.ID ?? "")") as? Data {
            let decoder = JSONDecoder()
            
            if sectionType == .movies {
                if let loadedItem = try? decoder.decode(ItemMovieDetail.self, from: savedItem) {
                    guard let presenter = interactor.presenter else {return}
                    let response = DetailDataModels.Detail.Response(section: sectionType, resultMovie: loadedItem, resultSerie: nil, errorMessage: nil)
                    presenter.presentItemDetail(response: response)
                }
            } else {
                if let loadedItem = try? decoder.decode(ItemSerieDetail.self, from: savedItem) {
                    guard let presenter = interactor.presenter else {return}
                    let response = DetailDataModels.Detail.Response(section: sectionType, resultMovie: nil, resultSerie: loadedItem, errorMessage: nil)
                    presenter.presentItemDetail(response: response)
                }
            }
        }
        
        
        
        let request = DetailDataModels.Detail.Request(section: sectionType, itemID: itemDetail?.ID ?? "")
        interactor.getDetailOfItem(request: request)
    }
}

extension DetailDataViewController: DetailDataDisplayLogic {
    func displayItem(viewModel: DetailDataModels.Detail.ViewModel) {
        showOrHideSpinner(spinner: loadingView, mustHideSpinner: true)
        
        guard let data = viewModel.displayedItem else {return}
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {return }
            `self`.posterImage.downloadedFrom(link: data.posterURL)
            `self`.titleLabel.text = data.title
            `self`.dataDetails = data.detailData
        }
    }
    
    func displayErrorGettingItems(viewModel: DetailDataModels.Detail.ViewModel) {
        showOrHideSpinner(spinner: loadingView, mustHideSpinner: true)
        alert(message: "Error Getting Data", title: viewModel.errorMessage ?? "Bad Connection")
    }
}


extension DetailDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DetailDataTableViewCell else {
            let customCell = UITableViewCell()
            customCell.textLabel?.text = "No Data"
            return customCell
        }
        
        let itemData = dataDetails[indexPath.row]
        cell.dataLabel.text = itemData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
