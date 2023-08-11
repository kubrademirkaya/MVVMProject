//
//  UserListTableViewCell.swift
//  MVVMProject
//
//  Created by Kübra Demirkaya on 11.08.2023.
//

import Foundation
import UIKit
import SnapKit

class UserListTableViewCell: UITableViewCell {
    
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
    
    public func configure(model: User) {
        
        labelId.text = String(model.id)
        labelName.text = model.name
        labelSurname.text = model.surname
        labelBirthday.text = model.birthday
        labelEmail.text = model.email
        
    }
}
