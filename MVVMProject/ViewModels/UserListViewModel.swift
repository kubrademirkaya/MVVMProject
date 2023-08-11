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
    
    private var cellViewModels: [UserListCellViewModel] = [UserListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue: Bool = false
    
    var selectedUser: User?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

   
    init( apiService: APIServiceProtocol = APIService()) {
            self.apiService = apiService
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.fetchUserInfo { [weak self] (success, users, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processFetchedPhoto(users: users)
            }
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> UserListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( user: User ) -> UserListCellViewModel {
        
        return UserListCellViewModel ( labelId: user.id,
                                       labelName: user.name,
                                       labelSurname: user.surname,
                                       labelBirthday: user.birthday,
                                       labelEmail: user.email)

    }
    
    private func processFetchedPhoto( users: [User] ) {
        self.users = users // Cache
        var vms = [UserListCellViewModel]()
        for user in users {
            vms.append( createCellViewModel(user: user) )
        }
        self.cellViewModels = vms
    }
    
}


struct UserListCellViewModel {
    
    let labelId: Int
    let labelName: String
    let labelSurname: String
    let labelBirthday: String
    let labelEmail: String
}
