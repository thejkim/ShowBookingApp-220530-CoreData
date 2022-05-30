//
//  BusScheduleVC.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/25/22.
//

import UIKit

enum Mode {
    case create, book
}

class BusScheduleVC: UIViewController, AddNewBusScheduleVCDelegate {

    @IBOutlet weak var busScheduleTV: UITableView!
    
    var scheduledBuses = [Dictionary<String, Any>]()
    
    var scheduledBuses1 = [BusSchedule]()
    
    var mode = Mode.create
    var selectedBusID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        var tempBusInfo = Dictionary<String, Any>()
        
        for bus in CoreDataManager.sharedManager.getAllBusesScheduled() {
            tempBusInfo["busID"] = bus.busID
            tempBusInfo["arrival"] = bus.arrival
            tempBusInfo["departure"] = bus.departure
            tempBusInfo["arrivalDateTime"] = bus.arrivalDateTime
            tempBusInfo["departureDateTime"] = bus.departureDateTime
            scheduledBuses.append(tempBusInfo)
        }
        

    }
    
    // AddNewBusScheduleVCDelegate required function
    func reloadTV() {
        var tempBusInfo = Dictionary<String, Any>()
        scheduledBuses = []
        
        for bus in CoreDataManager.sharedManager.getAllBusesScheduled() {
            tempBusInfo["busID"] = bus.busID
            tempBusInfo["arrival"] = bus.arrival
            tempBusInfo["departure"] = bus.departure
            tempBusInfo["arrivalDateTime"] = bus.arrivalDateTime
            tempBusInfo["departureDateTime"] = bus.departureDateTime
            scheduledBuses.append(tempBusInfo)
        }
        mode = .create
        busScheduleTV.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if mode == .create {
            let destination = segue.destination as! AddNewBusScheduleVC
            destination.delegate = self
        } else {
            let destination = segue.destination as! UserInfoVC
            destination.selectedBusID = selectedBusID
        }
    }

}

extension BusScheduleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return scheduledBuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("\(#function)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusScheduleCell", for: indexPath) as! BusScheduleCell
        
        let targetBus = scheduledBuses[indexPath.row]
        cell.busIdLabel.text = targetBus["busID"] as? String
        cell.destinationLabel.text = targetBus["arrival"] as? String
        cell.sourceLabel.text = targetBus["departure"] as? String
        cell.arrivalDateTimePicker.date = targetBus["arrivalDateTime"] as? Date ?? Date()
        cell.departureDateTimePicker.date = targetBus["departureDateTime"] as? Date ?? Date()
        print("targetBus[busToSeat]: \(targetBus["busToSeat"])")

        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mode = .book
        selectedBusID = (scheduledBuses[indexPath.row])["busID"] as! String
        performSegue(withIdentifier: "UserInfoSegue", sender: self)
    }
    
    
    
}
