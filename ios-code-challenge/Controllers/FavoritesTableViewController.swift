//
//  FavoritesTableViewController.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/7/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var favoriteBusinesses = [YLPBusiness]()
    private var business = YLPBusiness()
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
    lazy private var dataService: DataService = {
        return DataService()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
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
    
    // MARK: - Private
    private func fetchData() {
        dataService.fetchData { [weak self] favorites in
            self?.favoriteBusinesses = favorites
            self?.dataSource?.setObjects(self?.favoriteBusinesses)
            self?.tableView.reloadData()
        }
    }
}


