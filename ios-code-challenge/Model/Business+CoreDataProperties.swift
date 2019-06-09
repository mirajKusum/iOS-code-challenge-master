//
//  Business+CoreDataProperties.swift
//  
//
//  Created by Kusum Miraj on 6/8/19.
//
//

import Foundation
import CoreData


extension Business {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Business> {
        return NSFetchRequest<Business>(entityName: "Business")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var categories: [Dictionary<String, String>]?
    @NSManaged public var reviewCount: Int16
    @NSManaged public var distance: Double
    @NSManaged public var imageURLString: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var rating: Double

}
