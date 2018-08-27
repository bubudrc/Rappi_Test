//
//  ListDataViewController.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit


protocol ListDataDisplayLogic: class {
    func displayItems(viewModel: ListDataModels.List.ViewModel)
    func displayErrorGettingItems(viewModel: ListDataModels.List.ViewModel)
}

class ListDataViewController: UIViewController {
    
    let cellIdentifier = "listTableCellIdentifier"
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    var sectionType: Constants.Sections = .movies
    var sortedBy: Constants.SortedKind = .popular
    
    private var loadingView = UIView()
    
    var itemsData: [ListDataModels.List.ViewModel.DisplayedItem] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return }
                `self`.tableView.reloadData()
            }
        }
    }
    
    var interactor: ListDataInteractor?
    var router: ListDataRouter?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = sectionType.title
        
        tableView.estimatedRowHeight = 132.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        loadingView = createSpinner()
        setup()
        getItems()
    }

    //MARK: IBAction
    @IBAction func segmentedControlChanged(_ sender: Any) {
        switch self.segmentedControl.selectedSegmentIndex {
            
        case 0:
            sortedBy = .popular
            getItems()
        case 1:
            sortedBy = .topRated
            getItems()
        case 2:
            sortedBy = .upcoming
            let apiDateFormatter = DateFormatter()
            apiDateFormatter.dateFormat = "yyyy-MM-dd"
            let dateParam = apiDateFormatter.string(from: Date())
            getItems(withQueries: ["primary_release_date.gte":dateParam])
        default: break
        }
    }
    
    //MARK: Private
    func setup(){
        let interactor = ListDataInteractor()
        let presenter = ListDataPresenter()
        let router = ListDataRouter()
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        self.interactor = interactor
        self.router = router
    }

}

extension ListDataViewController {
    fileprivate func getItems(withQueries queries: [String:String]? = nil) {

        showOrHideSpinner(spinner: loadingView, mustHideSpinner: false)
        guard let interactor = self.interactor else { return }
        
        if let savedSection = UserDefaults.standard.object(forKey: "\(sectionType.title)-\(sortedBy.rawValue.description)") as? Data {
            let decoder = JSONDecoder()
            if let loadedSection = try? decoder.decode(ResponseRequest.self, from: savedSection) {
                guard let presenter = interactor.presenter else {return}
                let response = ListDataModels.List.Response(result: loadedSection.results, errorMessage: nil)
                presenter.presentItems(response: response)
            }
        }
        
        
        let request = ListDataModels.List.Request(section: sectionType, sortedBy: sortedBy, queries: queries)
        interactor.getListOfItems(request: request)
    }
}

extension ListDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListDataTableViewCell else {
            return UITableViewCell()
        }
        
        let itemData = itemsData[indexPath.row]
        cell.item = itemData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        guard let router = router else { return }
        let itemData = itemsData[indexPath.row]
        router.routeToItemDetail(withItem: itemData, forSection: sectionType)
    }

}

extension ListDataViewController: ListDataDisplayLogic {
    func displayItems(viewModel: ListDataModels.List.ViewModel) {
        showOrHideSpinner(spinner: loadingView, mustHideSpinner: true)
        itemsData = viewModel.displayedItems
    }
    
    func displayErrorGettingItems(viewModel: ListDataModels.List.ViewModel) {
        showOrHideSpinner(spinner: loadingView, mustHideSpinner: true)
        alert(message: "Error Getting Data", title: viewModel.errorMessage ?? "Bad Connection")
    }
}
