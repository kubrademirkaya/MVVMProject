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
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        return tableView
    }()
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    func initView() {
        self.navigationItem.title = "Users"
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initVM() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
        
        setupViews()
        
    }
    
    func setupViews() {
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else {
            fatalError("Error")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.userListCellViewModel = cellVM
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155.0
    }
    
}



class UserTableViewCell: UITableViewCell {
    
    private lazy var labelId:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var labelName:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var labelSurname:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var labelBirthday:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var labelEmail:UILabel = {
        let label = UILabel()
        return label
    }()


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required  init?(coder: NSCoder) {
        fatalError(" ")
    }
    
//    public func configure(model: User) {
//
//
//
//    }
    
    public func setupViews() {
        
        self.contentView.backgroundColor = .white
        
        self.addSubviews(labelId,
                         labelName,
                         labelSurname,
                         labelBirthday,
                         labelEmail)
        
       setupLayout()
    }
    
    public func setupLayout() {
        
        labelId.snp.makeConstraints { label in
            label.top.equalTo(self.contentView.safeAreaLayoutGuide.snp.top)
            label.leading.equalToSuperview().offset(16)
            label.trailing.equalToSuperview().offset(-16)
        }
        
        labelName.snp.makeConstraints { label in
            label.top.equalTo(labelId.snp.bottom).offset(8)
            label.leading.equalTo(labelId.snp.leading)
            label.trailing.equalTo(labelId.snp.trailing)
        }
        
        labelSurname.snp.makeConstraints { label in
            label.top.equalTo(labelName.snp.bottom).offset(8)
            label.leading.equalTo(labelName.snp.leading)
            label.trailing.equalTo(labelName.snp.trailing)
        }
        
        labelBirthday.snp.makeConstraints { label in
            label.top.equalTo(labelSurname.snp.bottom).offset(8)
            label.leading.equalTo(labelSurname.snp.leading)
            label.trailing.equalTo(labelSurname.snp.trailing)
        }
        
        labelEmail.snp.makeConstraints { label in
            label.top.equalTo(labelBirthday.snp.bottom).offset(8)
            label.leading.equalTo(labelBirthday.snp.leading)
            label.trailing.equalTo(labelBirthday.snp.trailing)
            label.bottom.equalTo(self.contentView.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }
    
    var userListCellViewModel : UserListCellViewModel? {
        didSet {
            
            guard let userListCellViewModel = userListCellViewModel else { return }
            
            labelId.text = String(userListCellViewModel.labelId)
            labelName.text = userListCellViewModel.labelName
            labelSurname.text = userListCellViewModel.labelSurname
            labelBirthday.text = userListCellViewModel.labelBirthday
            labelEmail.text = userListCellViewModel.labelEmail
        }
    }

}

