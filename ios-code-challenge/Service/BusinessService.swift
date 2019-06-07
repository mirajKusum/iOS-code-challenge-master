//
//  BusinessService.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/6/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

struct BusinessService {
    var business: YLPBusiness
    
    func setRating() -> String {
        return String("Rating: \(business.rating)")
    }
    
    func setDistance() -> String {
        return String(format: "%.02f miles", business.distance/1000)
    }
    
    func setReview() -> String {
        return String("\(business.reviewCount) reviews")
    }
    
    func setCategory() -> String {
        guard let categories = business.categories as? [Dictionary<String, String>] else { return "" }
        
        let categoryArray = categories.map { $0["title"]! }
        return categoryArray.joined(separator: ", ")
    }
    
    func setImage(completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: business.imageURLString) else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }
    }
}
