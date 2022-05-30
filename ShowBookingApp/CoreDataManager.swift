//
//  CoreDataManager.swift
//  AirplaneTicketManager
//
//  Created by Jeonghoon Oh on 5/23/22.
//

import Foundation
import CoreData
import UIKit
class CoreDataManager {
  
    static let sharedManager = CoreDataManager() // Singleton
    private var managedContext: NSManagedObjectContext
    private var seatEntity: NSEntityDescription


    private init() {
        managedContext = appDelegate.persistentContainer.viewContext
        seatEntity = NSEntityDescription.entity(forEntityName: "Seat", in: managedContext)!
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func createSeatRecord(with data: Dictionary<String, Any>) -> Seat {
        print("\(#function) seat created")
        let managedObject = Seat(context: managedContext)
        managedObject.setValue(data["id"], forKey: "id")
        managedObject.setValue(data["section"], forKey: "section")
        managedObject.setValue(data["row"], forKey: "row")
        managedObject.setValue(data["col"], forKey: "col")
        managedObject.setValue(data["booked"], forKey: "booked")
//        managedObject.setValue(data["username"], forKey: "username")
                
        appDelegate.saveContext()
        return managedObject
    }
    
    func createBusSchedule(with data: Dictionary<String, Any>) {
        let managedObject = Bus(context: managedContext)
        managedObject.setValue(data["busID"], forKey: "busID")
        managedObject.setValue(data["departure"], forKey: "departure")
        managedObject.setValue(data["departureDateTime"], forKey: "departureDateTime")
        managedObject.setValue(data["arrival"], forKey: "arrival")
        managedObject.setValue(data["arrivalDateTime"], forKey: "arrivalDateTime")
        appDelegate.saveContext()
    }
    
    func createUser(with username: String, hasMembership: Int) {
        let managedObject = User(context: managedContext)
        managedObject.setValue(username, forKey: "username")
        managedObject.setValue(hasMembership, forKey: "hasMembership")
        appDelegate.saveContext()
    }
    
    func assignSeatToBus(seat: Seat, toBusID: String) {
        print("passed busID: \(toBusID)")
        var managedObject = Bus(context: managedContext)
        let fetchRequest = NSFetchRequest<Bus>(entityName: "Bus")
        fetchRequest.predicate = NSPredicate(format: "busID = %@", toBusID)
        fetchRequest.fetchLimit = 1
        
        do {
            managedObject = try managedContext.fetch(fetchRequest).first!
            managedObject.addToBusToSeat(seat)
            appDelegate.saveContext()
        } catch {
            print("Failed to fetch target bus")
        }
    }
    
    func getSeatRecordFor(id: String) -> Seat {
        print("\(#function) here")
        var result: NSManagedObject!
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Seat")

        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        fetchRequest.fetchLimit = 1

        do
        {
            let records = try managedContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records[0] as! Seat
                return result as! Seat
            }
        } catch {
            print("Failed to get seat record for given id")
        }
        return result as! Seat
    }
    
    func getUserInfo(username: String) -> User? {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username = %@", username)
        do {
            let fetchedUser = try managedContext.fetch(fetchRequest).first
            return fetchedUser
        } catch {
            return nil
        }
    }
    
    func getAllBusesScheduled() -> [Bus] {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Bus")
        print("fetchRequest.resultType = \(fetchRequest.resultType)")
        do {
            let results = try managedContext.fetch(fetchRequest)
//            print("type(of: results) = \(type(of: results))")
            if let results = results as? [NSManagedObject] {
                return results as! [Bus]
            } else {
                return []
            }
        } catch {
            print("Failed to get all busses scheduled")
            return []
        }

    }
    
    func getBusScheduleFor(username: String) -> [Bus] {
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username = %@", username)
        do {
            let fetchedUser = try managedContext.fetch(fetchRequest).first as! User
            
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bus")
            fetchRequest.predicate = NSPredicate(format: "ANY busToUser = %@", fetchedUser)
            let fetchedBus = try managedContext.fetch(fetchRequest) as! [Bus]
            return fetchedBus
            
            
        } catch {
            
        }
        
        return []
    }
    
    func getSeatBookedForBusAndUser(busID: String, username: String) -> [Seat] {
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "username = %@", username)
        do {
            let fetchedUser = try managedContext.fetch(fetchRequest).first as! User
            
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bus")
            fetchRequest.predicate = NSPredicate(format: "busID = %@", busID)
            let fetchedBus = try managedContext.fetch(fetchRequest).first as! Bus
            
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Seat")
            fetchRequest.predicate = NSPredicate(format: "seatToUser = %@", fetchedUser)
            let fetchedSeats = try managedContext.fetch(fetchRequest) as! [Seat]
            
            return fetchedSeats
            
            
        } catch {
            print("Failed to fetch seat info for the bus and user")
            return []

        }
    }
    
    
    func assignUserToBus(busID: String, username: String) {
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bus")
        fetchRequest.predicate = NSPredicate(format: "busID = %@", busID)
        
        do {
            var fetchedBus = try managedContext.fetch(fetchRequest).first as! Bus
            
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "username = %@", username)
            
            let fetchedUser = try managedContext.fetch(fetchRequest).first as! User
            fetchedBus.addToBusToUser(fetchedUser)
            
        } catch {
            print("Failed to assign user to bus")
        }
        
    }
    
    func setSeatBooked(busID: String, id: String, username: String) {
        var result: NSManagedObject!

        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bus")

        fetchRequest.predicate = NSPredicate(format: "busID = %@", busID)
        
        do {
            let fetchedBus = try managedContext.fetch(fetchRequest).first as! Bus
            
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "username = %@", username)
            let fetchedUser = try managedContext.fetch(fetchRequest).first as! User
            
//            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Seat")
//            fetchRequest.predicate = NSPredicate(format: "seatToBus = %@", fetchedBus)
            
            
            
            let fetchRequest2: NSFetchRequest<Seat>
            fetchRequest2 = Seat.fetchRequest()
            
            let busPredicate = NSPredicate(format: "seatToBus = %@", fetchedBus)
            let seatIDPredicate = NSPredicate(format: "id = %@", id)
            
            fetchRequest2.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    busPredicate,
                    seatIDPredicate
                ]
            )

            let fetchedSeat = try managedContext.fetch(fetchRequest2).first!
            
            
//            let fetchedSeat = try managedContext.fetch(fetchRequest).first as! Seat
            fetchedSeat.setValue(true, forKey: "isBooked")
            fetchedSeat.setValue(fetchedUser, forKey: "seatToUser")
            
            
        } catch {
            print("Failed to set booked and assign user to seat")
        }
        
        appDelegate.saveContext()
        
    }
    
    // TODO: Optimize it
    func setSeatOpen(busID: String, id: String, username: String) {
        var result: NSManagedObject!

        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bus")

        fetchRequest.predicate = NSPredicate(format: "busID = %@", busID)
        
        do {
            let fetchedBus = try managedContext.fetch(fetchRequest).first as! Bus
            
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "username = %@", username)
            let fetchedUser = try managedContext.fetch(fetchRequest).first as! User
            
            let fetchRequest2: NSFetchRequest<Seat>
            fetchRequest2 = Seat.fetchRequest()
            
            let busPredicate = NSPredicate(format: "seatToBus = %@", fetchedBus)
            let seatIDPredicate = NSPredicate(format: "id = %@", id)
            
            fetchRequest2.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    busPredicate,
                    seatIDPredicate
                ]
            )

            let fetchedSeat = try managedContext.fetch(fetchRequest2).first!
            
            fetchedSeat.setValue(false, forKey: "isBooked")
            fetchedSeat.setValue(nil, forKey: "seatToUser")
            
            
        } catch {
            print("Failed to set booked and assign user to seat")
        }
            
        
        appDelegate.saveContext()
        
    }
    
    func isSeatRecordFound(busID: String, id: String) -> Bool {
        
        // Fetch Bus busID == busID
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bus")
        fetchRequest.predicate = NSPredicate(format: "busID = %@", busID)
        do {
            let busResult = try managedContext.fetch(fetchRequest).first as! Bus
            
            
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Seat")
            let busPredicate = NSPredicate(format: "seatToBus = %@", busResult)
            fetchRequest.predicate = busPredicate
            let tempBus = try! managedContext.fetch(fetchRequest)
            
            let seatIDPredicate = NSPredicate(format: "id = %@", id)
            fetchRequest.predicate = seatIDPredicate
            let tempSeat = try! managedContext.fetch(fetchRequest)
            
            
            fetchRequest.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    busPredicate,
                    seatIDPredicate
                ]
            )
            
            do {
                let fetchedSeat = try managedContext.fetch(fetchRequest) as! [Seat]
                if fetchedSeat.count != 0 {
                    return true
                }
            } catch {
                print("Failed......")
                return false
            }
            
            
//            if busResult.busToSeat?.count != 0 {
//                return true
//            } else {
//                return false
//            }
        } catch {
            print("Failed to fetch any seat for the bus")
            return false
        }
        return false
    }
    
    func isSeatBooked(busID: String, id: String) -> Bool {
        print("passed id: \(id)")
        var result: NSManagedObject!
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bus")

        fetchRequest.predicate = NSPredicate(format: "busID = %@", busID)

        do {
            let fetchedBus = try managedContext.fetch(fetchRequest).first as! Bus
            
//            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Seat")
//            fetchRequest.predicate = NSPredicate(format: "seatToBus = %@", fetchedBus)
////            let fetchedSeats = try managedContext.fetch(fetchRequest) as! [Seat]
//
//            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Seat")
//            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
            
            let fetchRequest2: NSFetchRequest<Seat>
            fetchRequest2 = Seat.fetchRequest()
            
            let busPredicate = NSPredicate(format: "seatToBus = %@", fetchedBus)
            let seatIDPredicate = NSPredicate(format: "id = %@", id)
            
            fetchRequest2.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [
                    busPredicate,
                    seatIDPredicate
                ]
            )

            let fetchedSeat = try managedContext.fetch(fetchRequest2).first!
            print("\(#function) fetchedSeat.isBooked: \(fetchedSeat.isBooked)")
            return fetchedSeat.isBooked
            
        
        
        } catch {
            print("Failed.......")
            return false

        }
        
        
//        do {
//            let fetchedBus = try managedContext.fetch(fetchRequest).first as! Bus
//            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Seat")
//            let busPredicate = NSPredicate(format: "seatToBus = %@", fetchedBus)
//            fetchRequest.predicate = busPredicate
//            let tempBus = try! managedContext.fetch(fetchRequest)
//
//            let seatIDPredicate = NSPredicate(format: "id = %@", id)
//            fetchRequest.predicate = seatIDPredicate
//            let tempSeat = try! managedContext.fetch(fetchRequest)
//
//
//            fetchRequest.predicate = NSCompoundPredicate(
//                andPredicateWithSubpredicates: [
//                    busPredicate,
//                    seatIDPredicate
//                ]
//            )
//            do {
//                let fetchedSeat = try managedContext.fetch(fetchRequest) as! [Seat]
//                return fetchedSeat[0].isBooked
//            } catch {
//                print("Failed...")
//                return false
//            }
//        } catch {
//            print("Failed...")
//            return false
//        }
        
        
//        do
//        {
//            let records = try managedContext.fetch(fetchRequest)
//            if let records = records as? [NSManagedObject] {
//                result = records[0] as! Seat
//
//                let isBooked = result.value(forKey: "booked") as! Bool
//                if isBooked {
//                    return true
//                } else {
//                    return false
//                }
//            }
//        } catch {
//            print("Failed to read booked value for given obj")
//        }
//        return false
        
        
    }
    
}
