//
//  YLPCoordinateSearchQuery.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/7/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation
import CoreLocation

class YLPCoordinateSearchQuery: YLPSearchQuery {
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init(location: "")
    }
    
    override func parameters() -> [AnyHashable : Any] {
        var params = [String: Any]()
        
        params["latitude"] = coordinate.latitude
        params["longitude"] = coordinate.longitude
        if let term = term, radiusFilter > 0 {
            params["term"] = term
            params["radius"] = radiusFilter
        }
        
        if let categoryFilter = categoryFilter, !categoryFilter.isEmpty {
            params["categories"] = categoryFilter.joined(separator: ", ")
        }
        
        return params
    }
}
