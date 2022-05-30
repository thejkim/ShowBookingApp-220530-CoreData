//
//  BusScheduleCell.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/25/22.
//

import UIKit

class BusScheduleCell: UITableViewCell {
    
    @IBOutlet weak var busIdLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var departureDateTimePicker: UIDatePicker!
    @IBOutlet weak var arrivalDateTimePicker: UIDatePicker!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

//protocol BusScheduleCellDelegate {
//    func busSchedule(didSetWith busID: String, from departure: String, departAt departDate: Date, to arrival: String, arriveAt arrivalDate: Date)
//}
