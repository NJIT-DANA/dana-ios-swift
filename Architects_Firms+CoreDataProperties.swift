//
//  Architects_Firms+CoreDataProperties.swift
//  
//
//  Created by Littman Library on 2/7/22.
//
//

import Foundation
import CoreData


extension Architects_Firms {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Architects_Firms> {
        return NSFetchRequest<Architects_Firms>(entityName: "Architects_Firms")
    }

    @NSManaged public var id: Int16
    @NSManaged public var fileUrl: String?
    @NSManaged public var details: String?
    @NSManaged public var imageUrl: String?

}
