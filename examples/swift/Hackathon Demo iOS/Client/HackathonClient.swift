//
//  HackathonClient.swift
//  Hackathon Demo iOS
//
//  Created by Peter Schwartz on 4/14/22.
//

import Foundation

//
//  OWMClient.swift
//  WeatherApp
//
//  Created by Peter Schwartz on 1/20/22.
//

import Foundation

class HackathonClient {
    static let apiKey = "API_KEY_GOES_HERE"
    static var accessToken = ""

    enum Endpoints {
        static let base = "https://api.stellantis-developers.com"

        case getBearerToken
        
        var urlString: String {
            switch self {
            case .getBearerToken:
                return Endpoints.base + "/v1/auth/token"
            }
        }
    }
    
    class func taskForRequest<ResponseType: Decodable>(request: URLRequest, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                        completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func taskForVehicleDataRequest(request: URLRequest, completion: @escaping (VehicleDataResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                if let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                    let response: VehicleDataResponse = VehicleDataResponse(data: jsonResult)!
                    print("Response: \(response.data)")
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func getBearer(completion: @escaping (BearerTokenResponse?, Error?) -> Void) -> Void {
        let url = Endpoints.getBearerToken.urlString
        var request = URLRequest(url: URL(string: url)!)
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("USERNAME_GOES_HERE", forHTTPHeaderField: "user")
        request.addValue("PASSWORD_GOES_HERE", forHTTPHeaderField: "password")
        
        request.httpMethod = "POST"

        taskForRequest(request: request, responseType: BearerTokenResponse.self, completion: { response, error in
            if let response = response {
                completion(response, nil)
                accessToken = response.access_token
            } else {
                completion(nil, error)
            }
        })
    }
    
    class func getVehicleData(bearerToken: String, vin: String, completion: @escaping (VehicleDataResponse?, Error?) -> Void) -> Void {
        let url = Endpoints.base + "/v1/\(vin)/data/"
        var request = URLRequest(url: URL(string: url)!)
        
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        taskForVehicleDataRequest(request: request) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }

// ***************************************
// *** Only needed for account linking ***
// ***************************************
//
//
//    class func getLinkAccount(bearerToken: String, connected_account_email: String, connected_account_password:String, completion: @escaping (AccountLinkResponse?, Error?) -> Void) -> Void {
//        let url = Endpoints.getAccountLink.urlString
//        var request = URLRequest(url: URL(string: url)!)
//
//        request.addValue("application/json", forHTTPHeaderField: "accept")
//        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
//        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//
//        let parameters = "{\n  \"connected_account_email\": \"\(connected_account_email)\",\n  \"connected_account_password\": \"\(connected_account_password)\"\n}"
//        let postData = parameters.data(using: .utf8)
//        request.httpBody = postData
//
//        taskForRequest(request: request, responseType: AccountLinkResponse.self) { response, error in
//            if let response = response {
//                completion(response, nil)
//            } else {
//                completion(nil, error)
//            }
//        }
//    }
}
