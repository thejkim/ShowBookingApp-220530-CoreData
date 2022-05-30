//
//  AddNewBusScheduleVC.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/25/22.
//

import UIKit

class AddNewBusScheduleVC: UIViewController {

    @IBOutlet weak var busIdTF: UITextField!
    @IBOutlet weak var departureInputTF: UITextField!
    @IBOutlet weak var arrivalInputTF: UITextField!
    @IBOutlet weak var departureDateTimeInputPicker: UIDatePicker!
    @IBOutlet weak var arrivalDateTimeInputPicker: UIDatePicker!
    
    var delegate: AddNewBusScheduleVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveBtnTouched(_ sender: UIBarButtonItem) {
        // TODO: SAVE BUS TO CORE DATA
        var busData: Dictionary<String, Any> = [:]
        busData["busID"] = busIdTF.text
        busData["departure"] = departureInputTF.text
        busData["departureDateTime"] = departureDateTimeInputPicker.date
        busData["arrival"] = arrivalInputTF.text
        busData["arrivalDateTime"] = arrivalDateTimeInputPicker.date
        print("busData: \(busData)")

        CoreDataManager.sharedManager.createBusSchedule(with: busData)
        
        if let delegate = delegate {
            print("delegate...")
            delegate.reloadTV()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func departureDateTimeSet(_ sender: UIDatePicker) {
        print(sender.date)
    }
    
    @IBAction func arrivalDateTimeSet(_ sender: UIDatePicker) {
        print(sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

extension AddNewBusScheduleVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

protocol AddNewBusScheduleVCDelegate {
    func reloadTV()
}
