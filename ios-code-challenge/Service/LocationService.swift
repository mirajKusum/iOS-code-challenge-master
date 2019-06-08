//
//  LocationService.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/6/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationService {
    lazy private var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    var locationCoordinate: CLLocationCoordinate2D?
    
    mutating func setDelegate(viewController: CLLocationManagerDelegate) {
        locationManager.delegate = viewController
    }
    
    mutating func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}
