//
//  VehicleDataResponse.swift
//  Hackathon Demo iOS
//
//  Created by Peter Schwartz on 4/14/22.
//

import Foundation
import UIKit

struct VehicleDataResponse {
    
    let plan: Int
    let vin: String
    let app_timestamp: String
    let data: [String:Any]
    
    init(data: [String:Any], app_timestamp: String, plan: Int, vin: String) {
        self.data = data
        self.app_timestamp = app_timestamp
        self.vin = vin
        self.plan = plan
    }
    
    init?(data: [String:Any]?) {
        guard let results = data?["Items"] as? [Any],
            let first = results[0] as? [String:Any],
            let dataDict = first["data"] as? [String: Any],
            let appTimeStamp = first["app_timestamp"] as? String,
            let vinResponse = first["vin"] as? String,
            let planResponse = first["plan"] as? Int else {
            return nil
        }
    
        self.data = dataDict
        self.app_timestamp = appTimeStamp
        self.vin = vinResponse
        self.plan = planResponse
    }
}

struct DataObject {
    let vehicleSensorTitle : String
    let vehicleSensorValue : String
}

//struct Item : Codable {
//    let plan: Int
//    let vin: String
//    let app_timestamp: String
//    let data: [Data]
//}

//struct Data : Codable {
//    let TerrainModeStat: String
//    let RunFlatTireLow: String
//    let VehAccelPeak_X: String
//    let WakeupReason: String
//    let DaysToService: String
//    let PitchAngle: String
//    let WheelPulse: String
//    let AirSuspensionStatus: String
//    let LanguageSelected: String
//    let OilLifeSts: String
//    let BrakePedal: String
//    let VehAccelPeak_Y: String
//    let Elec_Stab_stst: String
//    let ATMPressure: String
//    let MaintenanceReminderStatus: String
//    //let Adblue_Stat : String
//    let RainSensorLevel: String
//    let DistanceToService: String
//    let RHeatedWindowSts: String
//    let GlobalDriveModeStatus: String
//    let CheckFuelCap: String
//    let RemoteStart: String
//    let Service_Stat: String
//    let OilLifeLeft: String
//    let FuelCapacity: String
//    let IntakeAirTemp: String
//    let RollAngle: String
//}
