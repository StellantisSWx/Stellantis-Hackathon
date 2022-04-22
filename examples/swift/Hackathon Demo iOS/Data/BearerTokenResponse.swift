//
//  BearerTokenResponse.swift
//  Hackathon Demo iOS
//
//  Created by Peter Schwartz on 4/14/22.
//

import Foundation
import UIKit

struct BearerTokenResponse : Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}
