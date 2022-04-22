//
//  ViewController.swift
//  Hackathon Demo iOS
//
//  Created by Peter Schwartz on 4/14/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [String:Any] = [:]
    var dataList: [DataObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        grabBearerToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func grabBearerToken() {
        let sampleVin = "VIN_GOES_HERE"
        HackathonClient.getBearer { response, error in
            if let response = response {
                print(response)
                self.getVehicleData(vin: sampleVin, bearerToken: response.access_token)
            }
        }
    }
    
    func getVehicleData(vin: String, bearerToken: String) {
        HackathonClient.getVehicleData(bearerToken: bearerToken, vin: vin) { response, error in
            if let response = response {
                print(response.data)
                for (key, value) in response.data {
                    let stringVal = String(describing: value)
                    let dataObject = DataObject(vehicleSensorTitle: key, vehicleSensorValue: stringVal)
                    self.dataList.append(dataObject)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        cell.textLabel?.text = dataList[indexPath.row].vehicleSensorTitle
        cell.detailTextLabel?.text = dataList[indexPath.row].vehicleSensorValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

