//
//  User.swift
//  MVVMProject
//
//  Created by Kübra Demirkaya on 11.08.2023.
//

import Foundation

struct Users : Codable {
    let users: [User]
}

struct User: Codable {
    var id: Int
    var name: String
    var surname: String
    var birthday: String
    var email: String
}

