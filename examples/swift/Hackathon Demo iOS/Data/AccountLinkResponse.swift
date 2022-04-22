//
//  AccountLinkResponse.swift
//  Hackathon Demo iOS
//
//  Created by Peter Schwartz on 4/14/22.
//


import Foundation
import UIKit

struct AccountLinkResponse : Codable {
    let result: String
    let connected_account_email: String
    let vins: [Vin]
}

struct Vin : Codable {
    let vin: String
    let nickname: String
}
