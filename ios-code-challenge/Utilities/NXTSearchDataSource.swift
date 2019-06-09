//
//  NXTSearchDataSource.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/7/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation
protocol NXTSearchDataSourceProtocol {
    func loadMoreObjects(with offset: NSInteger)
}

class NXTSearchDataSource: NXTDataSource {
    var filteredObjects = [YLPBusiness]()
    var isFiltering: Bool = false
    var total: NSInteger = 0
    var delegate: NXTSearchDataSourceProtocol?
    
    func filterObjectForSearchText(_ search: String) {
        guard let objects = objects as? [YLPBusiness], !search.isEmpty else { return }
        
        let filteredObjects = objects.filter { (business: YLPBusiness) -> Bool in
            return business.name.lowercased().contains(search.lowercased())
        }
        self.filteredObjects = filteredObjects
        isFiltering = true
    }
    
    // MARK: - Private methods
    
    private func displayObject(at indexpath: IndexPath) -> NXTCellForObjectDelegate {
        let object: NXTCellForObjectDelegate
        
        if isFiltering {
            object = filteredObjects[indexpath.row] as NXTCellForObjectDelegate
        } else {
            object = objects[indexpath.row] as! NXTCellForObjectDelegate
        }
        
        return object
    }
    
    func shouldLoadMoreObjects(after indexpath: IndexPath) -> Bool {
        return indexpath.row == objects.count - 1 && objects.count <= total
    }
    
    // MARK: - Tableview
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredObjects.count : objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = displayObject(at: indexPath)
        let cell : NXTDetailedBusinessTableViewCell = object.cellForObject(for: tableView) as! NXTDetailedBusinessTableViewCell
        cell.bindingData(for: object)
        
        if shouldLoadMoreObjects(after: indexPath) {
            delegate?.loadMoreObjects(with: objects.count)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = displayObject(at: indexPath)
        
        if tableViewDidSelectCell != nil {
            tableViewDidSelectCell(object)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
