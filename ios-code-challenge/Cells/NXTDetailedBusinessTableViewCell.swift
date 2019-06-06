//
//  NXTDetailedBusinessTableViewCell.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/5/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

 class NXTDetailedBusinessTableViewCell: NXTBusinessTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailImageview.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Private
    
    private func configureCell(with business: YLPBusiness) {
        nameLabel.text = business.name
        ratingLabel.text = String("Rating: \(business.rating)")
        distanceLabel.text = String(format: "%.02f miles", business.distance/1000)
        reviewLabel.text = String("\(business.reviewCount) reviews")
        configureImage(from: business.imageURLString)
        setCategoriesString(with: business.categories)
    }
    
    private func configureImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.thumbnailImageview.image = image
                    }
                }
            }
        }
    }
    
    private func setCategoriesString(with categories: [Any]) {
        guard let categories = categories as? [Dictionary<String, String>] else { return }
        
        let categoryArray = categories.map { $0["title"]! }
        categoryLabel.text = categoryArray.joined(separator: ", ")
    }
}

extension NXTDetailedBusinessTableViewCell: NXTBindingDataForObjectDelegate {
    func bindingData(for object: Any!) {
        guard let object = object as? YLPBusiness else {
            return
        }
        
        configureCell(with: object)
    }
}
