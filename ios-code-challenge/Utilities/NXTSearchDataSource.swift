//
//  NXTSearchDataSource.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/7/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

class NXTSearchDataSource: NXTDataSource {
    var filteredObjects = [YLPBusiness]()
    var isFiltering: Bool = false
    
    func filterObjectForSearchText(_ search: String) {
        guard let objects = objects as? [YLPBusiness], !search.isEmpty else { return }
        
        let filteredObjects = objects.filter { (business: YLPBusiness) -> Bool in
            return business.name.lowercased().contains(search.lowercased())
        }
        self.filteredObjects = filteredObjects
        isFiltering = true
    }
    
    func displayObject(at indexpath: IndexPath) -> NXTCellForObjectDelegate {
        let object: NXTCellForObjectDelegate
        
        if isFiltering {
            object = filteredObjects[indexpath.row]
        } else {
            object = objects[indexpath.row] as! NXTCellForObjectDelegate
        }
        
        return object
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredObjects.count : objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = displayObject(at: indexPath)
        let cell : NXTDetailedBusinessTableViewCell = object.cellForObject(for: tableView) as! NXTDetailedBusinessTableViewCell
        cell.bindingData(for: object)
        
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
