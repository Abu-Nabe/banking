//
//  TransactionCell.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 4/4/2023.
//

import UIKit

class TransactionCell: UITableViewCell
{
    var NameLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "Username"
        Label.textColor = UIColor(named: "Basic")
        Label.font = .boldSystemFont(ofSize: 14)
        return Label
    }()
    
    var TypeLabel: UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.text = "type"
        Label.textColor = UIColor(named: "Basic")
        Label.font = .systemFont(ofSize: 12)
        
        return Label
    }()
        
    let AmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 USD"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "Basic")
        return label
    }()
    
    let TimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(named: "Basic")
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(NameLabel)
        addSubview(AmountLabel)
        addSubview(TimeLabel)
        addSubview(TypeLabel)
    
        NameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        NameLabel.anchor(left: leftAnchor, paddingLeft: 20)
        
        TypeLabel.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 20, paddingBottom: 5)
        
        AmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        AmountLabel.anchor(right: rightAnchor, paddingRight: 20)
        
        
        TimeLabel.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 5, paddingRight: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


