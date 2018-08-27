//
//  HomeTabBarViewController.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        guard let moviesNVC = ListDataViewController.create() as? UINavigationController, let moviesVC = moviesNVC.childViewControllers.first as? ListDataViewController, let seriesNVC = ListDataViewController.create() as? UINavigationController, let seriesVC = seriesNVC.childViewControllers.first as? ListDataViewController else { return }

        
        moviesVC.sectionType = .movies
        seriesVC.sectionType = .series
        
        // Do any additional setup after loading the view.
        moviesNVC.tabBarItem = UITabBarItem(title: Constants.Sections.movies.title, image: #imageLiteral(resourceName: "movies"), selectedImage: nil)
        seriesNVC.tabBarItem = UITabBarItem(title: Constants.Sections.series.title, image: #imageLiteral(resourceName: "series"), selectedImage: nil)
        
//        let client = Client()
        
//        moviesListViewController.listsProvider = MoviesListsProvider(with: client)
//        moviesListViewController.detailPushingStrategy = MovieDetailPushingStrategy(with: MovieDetailProvider(with: client))
//
//        seriesListViewController.listsProvider = SeriesListsProvider(with: client)
//        seriesListViewController.detailPushingStrategy = SeriesDetailPushingStrategy(with: SeriesDetailProvider(with: client))
        
        self.viewControllers = [moviesNVC, seriesNVC]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
