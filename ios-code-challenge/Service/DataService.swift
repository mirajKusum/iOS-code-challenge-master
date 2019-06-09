//
//  DataService.swift
//  ios-code-challenge
//
//  Created by Kusum Miraj on 6/8/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation
import CoreData

class DataService {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ios-code-challenge")//, managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            print(storeDescription)
            if let error = error {
                fatalError("Unresolved Datamodel Error: \(error.localizedDescription)")
            }
        })
        
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                fatalError("Error saving data:\(error.localizedDescription)")
            }
        }
    }
    
    func fetchData(completion: @escaping (([YLPBusiness]) -> Void)) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Business")
        
        do {
            if let businesses = try context.fetch(fetchRequest) as? [Business] {
                let favorites = businesses.map { business  -> YLPBusiness in
                    var attributes = [String: Any]()
                    attributes["id"] = business.identifier
                    attributes["name"] = business.name
                    attributes["rating"] = String(format: "%.0f", business.rating)
                    attributes["review_count"] = String("\(business.reviewCount)")
                    attributes["distance"] = String("\(business.distance)")
                    attributes["price"] = business.price
                    attributes["image_url"] = business.imageURLString
                    attributes["categories"] = business.categories
                    attributes["isFavorite"] = true
                    
                    let favorite = YLPBusiness(attributes: attributes)
                    return favorite
                }
                completion(favorites)
            }
        } catch let error {
            print("Error fetching favorite business: \(error.localizedDescription)")
        }
    }
    
    func save(_ item: YLPBusiness) {
        var favorites = [YLPBusiness]()
        fetchData { (businesses) in
            favorites = businesses
        }
        
        if favorites.contains(where: { $0.identifier == item.identifier }) {
            return
        }
        
        let context = persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Business", in: context) {
            let favorite = NSManagedObject(entity: entity, insertInto: context)
            favorite.setValue(item.identifier, forKey: "identifier")
            favorite.setValue(item.name, forKey: "name")
            favorite.setValue(item.price, forKey: "price")
            favorite.setValue(item.categories, forKey: "categories")
            favorite.setValue(item.imageURLString, forKey: "imageURLString")
            favorite.setValue(item.rating, forKey: "rating")
            favorite.setValue(Int16(item.reviewCount), forKey: "reviewCount")
            favorite.setValue(item.distance, forKey: "distance")
            favorite.setValue(true, forKey: "isFavorite")
            
            saveContext()
        }
    }
}
