//
//  UserListViewController.swift
//  MVVMProject
//
//  Created by Kübra Demirkaya on 10.08.2023.
//

import UIKit
import SnapKit

class UserListViewController: UIViewController {

    lazy var viewModel: UserListViewModel = {
        return UserListViewModel()
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 30
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: "UserListTableViewCell")
        return tableView
    }()
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    
    
    //ViewModel Init Func
    func initViewModel() {
        
        viewModel.updateLoadingStatus = {
            DispatchQueue.main.async {
                let isLoading = self.viewModel.isLoading
                if isLoading {
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0
                    })
                }else {
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.fetchData()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
        
        setupViews()
        
    }
    
    func setupViews() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubviews(tableView,
                              activityIndicator)
        
        setupLayouts()
    }
    
    func setupLayouts() {
        
        tableView.snp.makeConstraints { tableView in
            tableView.edges.equalToSuperview()
        }
    }
}


extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as? UserListTableViewCell else {
            fatalError("Error")
        }
        
        let cellViewModel = viewModel.getCellViewModel( at: indexPath )
        cell.userListCellViewModel = cellViewModel
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155.0
    }
    
}


