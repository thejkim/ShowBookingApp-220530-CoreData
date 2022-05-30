//
//  User+CoreDataProperties.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/28/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var hasMembership: Int64
    @NSManaged public var username: String?
    @NSManaged public var userToBus: NSSet?

}

// MARK: Generated accessors for userToBus
extension User {

    @objc(addUserToBusObject:)
    @NSManaged public func addToUserToBus(_ value: Bus)

    @objc(removeUserToBusObject:)
    @NSManaged public func removeFromUserToBus(_ value: Bus)

    @objc(addUserToBus:)
    @NSManaged public func addToUserToBus(_ values: NSSet)

    @objc(removeUserToBus:)
    @NSManaged public func removeFromUserToBus(_ values: NSSet)

}

extension User : Identifiable {

}
