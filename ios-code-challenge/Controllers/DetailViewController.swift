//
//  DetailViewController.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!

    lazy private var favoriteBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Star-Outline"), style: .plain, target: self, action: #selector(onFavoriteBarButtonSelected(_:)))

    @objc var detailItem: YLPBusiness?
    
    private var _favorite: Bool = false
    private var isFavorite: Bool {
        get {
            return _favorite
        } 
    }
    
    lazy private var businessService: BusinessService? = {
        guard let business = self.detailItem else { return nil }
        return BusinessService(business: business)
    }()
    lazy private var dataService: DataService = {
        return DataService()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientView.isHidden = true
        configureView()
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientView.setGradientBackground(colorOne: UIColor.clear, colorTwo: UIColor.black)
    }
    
    private func configureView() {
        guard let detailItem = detailItem else { return }
        gradientView.isHidden = false
        nameLabel.text = detailItem.name
        priceLabel.text = detailItem.price
        ratingLabel.text = businessService?.setRating()
        reviewLabel.text = businessService?.setReview()
        categoryLabel.text = businessService?.setCategory()
        businessService?.setImage { [weak self] image in
            DispatchQueue.main.async {
                self?.imageview.image = image
            }
        }
        updateFavoriteBarButtonState()
    }
    
    func setDetailItem(newDetailItem: YLPBusiness) {
        guard detailItem != newDetailItem else { return }
        detailItem = newDetailItem
    }
    
    private func updateFavoriteBarButtonState() {
        guard let detailItem = detailItem else {
            favoriteBarButtonItem.image = UIImage(named: "Star-Outline")
            return
        }
        favoriteBarButtonItem.image = detailItem.isFavorite ? UIImage(named: "Star-Filled") : UIImage(named: "Star-Outline")
    }
    
    @objc private func onFavoriteBarButtonSelected(_ sender: Any) {
        detailItem?.isFavorite = true
        updateFavoriteBarButtonState()
        saveItemToStore()
    }
    
    private func saveItemToStore() {
        guard let detailItem = detailItem else { return }
        dataService.save(detailItem)
    }
}
