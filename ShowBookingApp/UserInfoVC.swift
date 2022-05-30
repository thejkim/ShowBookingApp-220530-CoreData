//
//  UserInfoVC.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/25/22.
//

import UIKit

class UserInfoVC: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var userTypeSegCont: UISegmentedControl!
    
    var hasMembership = 0
    var selectedBusID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func userTypeSetTo(_ sender: UISegmentedControl) {
        // hasMembership: Int
        // 0 : false
        // 1 : true
        hasMembership = sender.selectedSegmentIndex
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let username = usernameTF.text else { return }
        CoreDataManager.sharedManager.createUser(with: username, hasMembership: hasMembership) // SAVE USER
        let destination = segue.destination as! BookingCVVC
        destination.targetBusID = selectedBusID // Pass busID to BookingCVVC
        destination.targetUsername = username
    }
    
}

extension UserInfoVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
        usernameTF.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        usernameTF.resignFirstResponder()
    }
}
