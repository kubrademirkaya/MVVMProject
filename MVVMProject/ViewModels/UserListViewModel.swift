//
//  UserListViewModel.swift
//  MVVMProject
//
//  Created by Kübra Demirkaya on 10.08.2023.
//

import Foundation


class UserListViewModel {
    
    
    let apiService: APIServiceProtocol
    
    private var users: [User] = [User]()
    
    //activity Indicator
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var reloadTableViewClosure: (()->())?

    var updateLoadingStatus: (()->())?
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var showAlertClosure: (()->())?

   
    init( apiService: APIServiceProtocol = APIService()) {
            self.apiService = apiService
    }
    
    func fetchData(with callback: @escaping (([User]) -> Void)) {
        self.isLoading = true
        
        apiService.fetchUserInfo { [weak self] (success, users, error) in
            guard let this = self else { return }
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                this.users = users
                self?.isLoading = false
               callback(users)
            }
        }
    }
    
    func user(at index: Int) -> User {
        return users[index]
    }
    
    var userCount: Int {
        return users.count
    }
}



