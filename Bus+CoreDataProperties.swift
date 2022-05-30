//
//  Bus+CoreDataProperties.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/28/22.
//
//

import Foundation
import CoreData


extension Bus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bus> {
        return NSFetchRequest<Bus>(entityName: "Bus")
    }

    @NSManaged public var arrival: String?
    @NSManaged public var arrivalDateTime: Date?
    @NSManaged public var busID: String?
    @NSManaged public var departure: String?
    @NSManaged public var departureDateTime: Date?
    @NSManaged public var busToSeat: NSSet?
    @NSManaged public var busToUser: NSSet?

}

// MARK: Generated accessors for busToSeat
extension Bus {

    @objc(addBusToSeatObject:)
    @NSManaged public func addToBusToSeat(_ value: Seat)

    @objc(removeBusToSeatObject:)
    @NSManaged public func removeFromBusToSeat(_ value: Seat)

    @objc(addBusToSeat:)
    @NSManaged public func addToBusToSeat(_ values: NSSet)

    @objc(removeBusToSeat:)
    @NSManaged public func removeFromBusToSeat(_ values: NSSet)

}

// MARK: Generated accessors for busToUser
extension Bus {

    @objc(addBusToUserObject:)
    @NSManaged public func addToBusToUser(_ value: User)

    @objc(removeBusToUserObject:)
    @NSManaged public func removeFromBusToUser(_ value: User)

    @objc(addBusToUser:)
    @NSManaged public func addToBusToUser(_ values: NSSet)

    @objc(removeBusToUser:)
    @NSManaged public func removeFromBusToUser(_ values: NSSet)

}

extension Bus : Identifiable {

}
