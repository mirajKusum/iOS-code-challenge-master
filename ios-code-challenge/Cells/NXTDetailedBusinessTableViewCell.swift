//
//  NXTDetailedBusinessTableViewCell.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/5/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

 class NXTDetailedBusinessTableViewCell: NXTBusinessTableViewCell {

    private var business: YLPBusiness?
    lazy private var businessService: BusinessService? = {
        guard let business = self.business else { return nil }
        return BusinessService(business: business)
    }()
    
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
        self.business = business
        nameLabel.text = business.name
        ratingLabel.text = businessService?.setRating()
        distanceLabel.text = businessService?.setDistance()
        reviewLabel.text = businessService?.setReview()
        categoryLabel.text = businessService?.setCategory()
        businessService?.setImage { [weak self] image in
            DispatchQueue.main.async {
                self?.thumbnailImageview.image = image
            }
        }
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
