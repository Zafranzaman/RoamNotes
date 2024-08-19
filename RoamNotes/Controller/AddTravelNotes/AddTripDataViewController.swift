//
//  AddTripDataViewController.swift
//  RoamNotes
//
//  Created by Zafran Mac on 05/10/2023.
//

import UIKit

class AddTripDataViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var destinationTextField:UITextField!
    @IBOutlet weak var datePicker:UIDatePicker!
    // MARK: - Variables
    let dbmgr = dbmanager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Travel Detail"
        initialSetup()
    }
}

// MARK: - Actions
extension AddTripDataViewController {
    @IBAction func addTripButtonTapped(_ sender: Any) {
        guard let destination = destinationTextField.text else  {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        
        let query = "INSERT INTO AddTrip(destination,date) VALUES('\(destination)', '\(selectedDate)')"
        if dbmgr.CreateInsertUpdateDelete(query: query)
        {
            let alert = UIAlertController(title: "Alert", message: "Your Trip Data is Saved!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "Data Not Saved!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Methods
extension AddTripDataViewController {
    func initialSetup(){
        let query = "Create table if not exists AddTrip (id INTEGER PRIMARY KEY AUTOINCREMENT,destination text,date text)"
        if dbmgr.CreateInsertUpdateDelete(query: query){
            
        }
    }
    
}

// MARK: - ViewModel
extension AddTripDataViewController {
    
}
