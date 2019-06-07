//
//  NXTDataSource+Extension.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/6/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

extension NXTDataSource {
    func sort() {
        if var array = objects as? [YLPBusiness] {
            array.sort {
                return $0.distance < $1.distance
            }
            setObjects(array)
        }
    }
}
