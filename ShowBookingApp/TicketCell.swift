//
//  TicketCell.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/29/22.
//

import UIKit

class TicketCell: UITableViewCell {

    @IBOutlet weak var busID: UILabel!
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var departureTime: UIDatePicker!
    @IBOutlet weak var arrival: UILabel!
    @IBOutlet weak var arrivalTime: UIDatePicker!
    @IBOutlet weak var seatID: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
