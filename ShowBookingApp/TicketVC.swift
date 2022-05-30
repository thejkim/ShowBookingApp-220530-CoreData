//
//  TicketVC.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/25/22.
//

import UIKit

class TicketVC: UIViewController {
    
    @IBOutlet weak var ticketListTV: UITableView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userType: UILabel!
    
    var ticketName = ""
    var targetBusID = ""
    var targetUsername = ""
    
    var busScheduleList = [Dictionary<String, Any>]()
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = CoreDataManager.sharedManager.getUserInfo(username: targetUsername) {
            username.text = currentUser.username
            userType.text = (currentUser.hasMembership == 0) ? "General" : "Membership"
        }
        
        let busSchedules = CoreDataManager.sharedManager.getBusScheduleFor(username: targetUsername)
        print("busSchedules:\(busSchedules)")
        print("busSchedules.count: \(busSchedules.count)")
        
        var a = Dictionary<String, Any>()
        
        for bus in busSchedules {
            print("bus....")
            let seatsBookedForBusByUser = CoreDataManager.sharedManager.getSeatBookedForBusAndUser(busID: bus.busID!, username: targetUsername)
            print("seatsBookedForBusByUser.count: \(seatsBookedForBusByUser.count)")
            print("seatsBookedForBusByUser: \(seatsBookedForBusByUser)")
            for seat in seatsBookedForBusByUser {
                print("seatID: \(seat.id)")
                a["busID"] = seat.seatToBus?.busID
                a["departure"] = seat.seatToBus?.departure
                a["departureTime"] = seat.seatToBus?.departureDateTime
                a["arrival"] = seat.seatToBus?.arrival
                a["arrivalTime"] = seat.seatToBus?.arrivalDateTime
                a["seatID"] = seat.id
                busScheduleList.append(a)
                
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewTicketVC
        destination.targetUsername = targetUsername
        
    }
    
    func createTicketPDF() -> String {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.view.bounds, nil)
        UIGraphicsBeginPDFPageWithInfo(self.view.bounds, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        
        self.view.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        
        let outputFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(targetUsername).pdf")
        
        do {
            try pdfData.write(to: outputFileURL, options: .atomic)
            print("outputFileURL.path: " + outputFileURL.path)
            url = outputFileURL
            return outputFileURL.path
        } catch {
            print("Failed to create PDF file")
            return ""

        }
        
    }


}

extension TicketVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        busScheduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! TicketCell
        cell.busID.text = ((busScheduleList[indexPath.row])["busID"] as! String)
        cell.arrival.text = ((busScheduleList[indexPath.row])["arrival"] as! String)
        cell.departure.text = ((busScheduleList[indexPath.row])["departure"] as! String)
        cell.arrivalTime.date = (busScheduleList[indexPath.row])["arrivalTime"] as! Date
        cell.departureTime.date = (busScheduleList[indexPath.row])["departureTime"] as! Date
        cell.seatID.text = ((busScheduleList[indexPath.row])["seatID"] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
