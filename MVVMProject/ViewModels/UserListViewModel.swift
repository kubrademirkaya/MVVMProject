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
    
    //activity Indicator
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    

    var reloadTableViewClosure: (()->())?

    var updateLoadingStatus: (()->())?

   
    init( apiService: APIServiceProtocol = APIService()) {
            self.apiService = apiService
    }
    
    func fetchData() {
        self.isLoading = true
        apiService.fetchUserInfo { [weak self] (success, users, error) in
            self?.isLoading = false
            if let error = error {
                print("error")
            } else {
                self?.processFetched(users: users)
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
    
    
    private func processFetched( users: [User] ) {
        self.users = users // Cache
        var vms = [UserListCellViewModel]()
        for user in users {
            vms.append( createCellViewModel(user: user) )
        }
        self.cellViewModels = vms
    }
    
}



