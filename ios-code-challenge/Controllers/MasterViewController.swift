//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import CoreLocation

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController?
    private var business = YLPBusiness()
    private var locationService = LocationService()
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy private var dataSource: NXTSearchDataSource? = {
        guard let dataSource = NXTSearchDataSource(objects: nil) else { return nil }
        dataSource.tableViewDidReceiveData = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }
        dataSource.tableViewDidSelectCell = { [weak self] business in
            if let business = business as? YLPBusiness {
                self?.business = business
            }
            self?.performSegue(withIdentifier: "showDetail", sender: self)
        }
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        locationService.setDelegate(viewController: self)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Business"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
        super.viewDidAppear(animated)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let controller = segue.destination as? UINavigationController else {
                return
            }
            
            if let detailVC = controller.viewControllers.first as? DetailViewController {
                detailVC.setDetailItem(newDetailItem: self.business)
                detailVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                detailVC.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

extension MasterViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationService.stopUpdatingLocation()
        searchBusinesses(near: location.coordinate)
    }
    
    private func searchBusinesses(near coordinate: CLLocationCoordinate2D) {
        let query = YLPCoordinateSearchQuery(coordinate: coordinate)
        AFYelpAPIClient.shared()?.search(with: query, completionHandler: { [weak self] (searchResult, error) in
            guard let strongSelf = self,
                let dataSource = strongSelf.dataSource,
                let businesses = searchResult?.businesses else {
                    return
            }
            dataSource.setObjects(businesses)
            dataSource.sort()
            strongSelf.tableView.reloadData()
        })
    }
}

extension MasterViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        dataSource?.filterObjectForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSource?.isFiltering = false
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
