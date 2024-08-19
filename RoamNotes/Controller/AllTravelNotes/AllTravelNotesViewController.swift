//
//  AllTravelNotesViewController.swift
//  RoamNotes
//
//  Created by Zafran Mac on 05/10/2023.
//

import UIKit

class AllTravelNotesViewController: UIViewController {
    
    // MARK: - Outlets
    var tripDataList = [Trip]()
    @IBOutlet weak var tableView:UITableView!
    // MARK: - Variables
    let dbmgr = dbmanager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
}

// MARK: - Actions
extension AllTravelNotesViewController {
    @IBAction func addButtonTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddTripDataViewController") as! AddTripDataViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Methods
extension AllTravelNotesViewController {
    func initialSetup(){
        
    }
    func fetchData() {
        tripDataList = dbmgr.getAllInfo()
        print(tripDataList)
        if tripDataList.isEmpty {
            tableView.backgroundColor = .clear
        }
        else {
            tableView.backgroundColor = .white
        }
        tableView.reloadData()
    }
    
}

extension AllTravelNotesViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripDataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AllTravelNotesTableViewCell
        let data = tripDataList[indexPath.row]
        cell.destinationLabel.text = data.destination
        cell.dateLabel.text = data.date
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let data = tripDataList[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AllSelectedTravelImagesViewController") as! AllSelectedTravelImagesViewController
        vc.TravelList = tripDataList
        vc.Index =  indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
