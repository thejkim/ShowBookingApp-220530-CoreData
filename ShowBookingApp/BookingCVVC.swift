//
//  BookingCVVC.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/25/22.
//

import UIKit

class BookingCVVC: UIViewController {

    @IBOutlet weak var seatsCV: UICollectionView!
    @IBOutlet weak var selectionListLabel: UILabel!
    
//    var numOfSection = 0
    var numOfColumn = 4
    var targetBusID = ""
    var targetUsername = ""
    
    let sections = ["Membership Only", "Business", "Economy", "Social Distance"]
    var selectedSeats = Set<String>()

    var count = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()

        let margin = seatsCV.layoutMargins.right
        let totalSpaceForMargin = margin * (CGFloat(numOfColumn)/2)
        let widthDividedIntoNumOfCol = ((view.frame.width - totalSpaceForMargin) / CGFloat(numOfColumn)) - margin
        layout.itemSize = CGSize(width: widthDividedIntoNumOfCol, height: widthDividedIntoNumOfCol)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 36) // header size

        seatsCV.collectionViewLayout = layout
        
        seatsCV.allowsMultipleSelection = true
//        seatsCV.reloadItems(at: <#T##[IndexPath]#>)
        
        for seat in CoreDataManager.sharedManager.getSeatBookedForBusAndUser(busID: targetBusID, username: targetUsername) {
            print("inserting \(seat.id) to selectedSeats...")
            if let id = seat.id {
                selectedSeats.insert(id)
                selectionListLabel.text! += "\(id) "
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /* SAVE TO SEAT, BUS
            1. set user(through relationship) to current bus
            2. set isBooked to true to seat(selectedSeats), set user(through relationship) to seat(selectedSeats)
        */
        CoreDataManager.sharedManager.assignUserToBus(busID: targetBusID, username: targetUsername)
        
        for seatID in selectedSeats {
            print("seatID in selectedSeats: \(seatID)")
            CoreDataManager.sharedManager.setSeatBooked(busID: targetBusID, id: seatID, username: targetUsername)
        }
        
        let destination = segue.destination as! TicketVC
        // Send busID and username to fetch seat info from Seat
        destination.targetBusID = targetBusID
        destination.targetUsername = targetUsername
    }

}

extension BookingCVVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SeatCVHeaderView", for: indexPath) as! SeatCVHeaderView
        header.sectionLabel.text = sections[indexPath.section]
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0: return 4
            case 1: return 12
            case 2: return 32
            default: return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCell", for: indexPath) as! SeatCell
        // TODO: Optimize row, col calculation
        let row = indexPath.row / sections.count
        let column = indexPath.row % sections.count
        let id = "\(indexPath.section):\(row)\(column)"
        

        cell.seatNumberLabel.text = id
        print("cell.seatNumberLabel.text: \(cell.seatNumberLabel.text)")
        
        var seat: Dictionary<String, Any>
        print("indexPath: \(indexPath)")
        if CoreDataManager.sharedManager.isSeatRecordFound(busID: targetBusID, id: id) {
            print("\(selectedSeats)")
            
            if selectedSeats.contains(id) {
                print("cell is selected")
                // Open it again, to allow update.
                CoreDataManager.sharedManager.setSeatOpen(busID: targetBusID, id: id, username: targetUsername)
                cell.seatImageView.image = UIImage(named: IBConstant.seatSelectImageName)
            } else {
                if CoreDataManager.sharedManager.isSeatBooked(busID: targetBusID, id: id) {
                    print("booked: \(id)")
                    
                    if indexPath.section == 3 && (column == 1 || column == 2) {
                        cell.seatImageView.image = UIImage(named: IBConstant.seatNotAvailableImageName)
                    } else {
                        cell.seatImageView.image = UIImage(named: IBConstant.seatBookedImageName)
                    }
                } else {
                    print("open: \(id)")
                    cell.seatImageView.image = UIImage(named: IBConstant.seatOpenImageName)
                }
            }
        } else {
            cell.seatImageView.image = UIImage(named: IBConstant.seatOpenImageName)
            
            if indexPath.section == 3 && (column == 1 || column == 2) {
                seat = ["id": id, "section": indexPath.section, "row": row, "column": column, "booked": true]
            } else {
                seat = ["id": id, "section": indexPath.section, "row": row, "column": column, "booked": false]
            }
            let newSeat = CoreDataManager.sharedManager.createSeatRecord(with: seat)
            print("targetBusID = \(targetBusID)")
            CoreDataManager.sharedManager.assignSeatToBus(seat: newSeat, toBusID: targetBusID)

        }

        return cell
        
    }
    
    // MARK: Select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select at \(indexPath.section) : \(indexPath.row)")
        
        if selectedSeats.count >= 5 {
            JKAlert.show(title: "Warning", message: "Cannot book more than 5 seats per person", on: self)
            return
        }
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! SeatCell
        
        let row = indexPath.row / sections.count
        let column = indexPath.row % sections.count
        let id = "\(indexPath.section):\(row)\(column)"
        JKLog.log(message: "\(cell.isSelected)")
        

        if CoreDataManager.sharedManager.isSeatBooked(busID: targetBusID, id: id) { // booked
            print(CoreDataManager.sharedManager.isSeatBooked(busID: targetBusID, id: id))

            if indexPath.section == 3 && (column == 1 || column == 2) {
                cell.seatImageView.image = UIImage(named: IBConstant.seatNotAvailableImageName)
            } else {
                cell.seatImageView.image = UIImage(named: IBConstant.seatBookedImageName)
            }
        } else { // open
            print(CoreDataManager.sharedManager.isSeatBooked(busID: targetBusID, id: id))

            if !selectedSeats.contains(id) {
                selectedSeats.insert(id)
                selectionListLabel.text = "Selected Seats: "
                for id in selectedSeats {
                    selectionListLabel.text! += "\(id) "
                }
                cell.seatImageView.image = UIImage(named: IBConstant.seatBookedImageName)

            } else {
                count += 1
                print("duplicate selection \(count)")
            }

            if count > 0 {
                print("already exists")
                selectedSeats.remove(id)
                selectionListLabel.text = "Selected Seats: "
                for id in selectedSeats {
                    selectionListLabel.text! += "\(id) "
                }
                count -= 1

                // TODO: Make array for selected seat's id to print out in selectionListLabel
                cell.seatImageView.image = UIImage(named: IBConstant.seatOpenImageName)
            }
            seatsCV.reloadData() // MARK: <- IT WAS PROBLEM THAT MAKES IT NOT TO CALL DIDDESELECTITEMAT
            cell.seatImageView.image = UIImage(named: IBConstant.seatSelectImageName)
        }
        

    }
    
    // MARK: Deselect
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("did deselect at \(indexPath.section) : \(indexPath.row)\n\n\n")
        let cell = collectionView.cellForItem(at: indexPath) as! SeatCell
        
        let row = indexPath.row / sections.count
        let column = indexPath.row % sections.count
        let id = "\(indexPath.section):\(row)\(column)"
        
        selectedSeats.remove(id)

        if CoreDataManager.sharedManager.isSeatBooked(busID: targetBusID, id: id) { // booked
            print("deselect")
        } else {
            cell.seatImageView.image = UIImage(named: IBConstant.seatOpenImageName)
        }
        
    }
    
    
}
