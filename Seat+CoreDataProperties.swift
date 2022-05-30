//
//  Seat+CoreDataProperties.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/28/22.
//
//

import Foundation
import CoreData


extension Seat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Seat> {
        return NSFetchRequest<Seat>(entityName: "Seat")
    }

    @NSManaged public var col: Int64
    @NSManaged public var id: String?
    @NSManaged public var isBooked: Bool
    @NSManaged public var row: Int64
    @NSManaged public var section: Int64
    @NSManaged public var seatToBus: Bus?
    @NSManaged public var seatToUser: User?

}

extension Seat : Identifiable {

}
