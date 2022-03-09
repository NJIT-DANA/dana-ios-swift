//
//  PublicArts+CoreDataProperties.swift
//  
//
//  Created by Littman Library on 2/22/22.
//
//

import Foundation
import CoreData


extension PublicArts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PublicArts> {
        return NSFetchRequest<PublicArts>(entityName: "PublicArts")
    }

    @NSManaged public var details: String?
    @NSManaged public var fileUrl: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?

}
