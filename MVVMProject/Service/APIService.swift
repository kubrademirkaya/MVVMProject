//
//  APIService.swift
//  MVVMProject
//
//  Created by Kübra Demirkaya on 10.08.2023.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchUserInfo( complete: @escaping ( _ success: Bool, _ users: [User], _ error: APIError? )->() )
}

class APIService: APIServiceProtocol {
    
    // Simulate a long waiting for fetching
    func fetchUserInfo( complete: @escaping ( _ success: Bool, _ users: [User], _ error: APIError? )->() ) {
        DispatchQueue.global().async {
            sleep(3)
            let path = Bundle.main.path(forResource: "content", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let users = try! decoder.decode(Users.self, from: data)
            complete( true, users.users , nil )
        }
    }
    
    
    
}
