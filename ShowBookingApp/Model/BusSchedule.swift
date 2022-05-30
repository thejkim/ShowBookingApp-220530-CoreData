//
//  BusSchedule.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/28/22.
//

import Foundation

class BusSchedule {
    var busID : String
    var departure : String
    var departureDateTime : Date
    var arrival : String
    var arrivalDateTime : Date
    var username : [String]?
    
    init(busID: String, departure: String, departureDateTime: Date, arrival: String, arrivalDateTime: Date) {
        self.busID = busID
        self.departure = departure
        self.departureDateTime = departureDateTime
        self.arrival = arrival
        self.arrivalDateTime = arrivalDateTime
    }
    
}
