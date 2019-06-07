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
    
    lazy private var dataSource: NXTDataSource? = {
        guard let dataSource = NXTDataSource(objects: nil) else { return nil }
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
