//
//  Transfer.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 4/4/2023.
//

import UIKit

class Transfer: UIViewController{
    
    let cellid = "cellid"
    var transactionData: [BankModel] = [BankModel]()
    
    let paypalView: CardView = {
        let view = CardView()
        view.backgroundColor = UIColor(named: "Basic2")
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "Gray2")!.cgColor
        return view
    }()
    
    let debitView: CardView = {
        let view = CardView()
        view.backgroundColor = UIColor(named: "Basic2")
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "Gray2")!.cgColor
        return view
    }()
    
    private let PaypalLabel: UILabel = {
        let label = UILabel()
        label.text = "Transfer to Paypal"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = UIColor(named: "Basic")
        
        return label
    }()
    
    private let DebitLabel: UILabel = {
        let label = UILabel()
        label.text = "Transfer to Bank Account"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = UIColor(named: "Basic")
        return label
    }()
    
    private let RecentLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Payments"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24.0)
        label.textColor = UIColor(named: "Basic")
        
        return label
    }()
    
    private let tableview: UITableView =
    {
        let tableview = UITableView()
            
        return tableview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(paypalView)
        view.addSubview(debitView)
        view.addSubview(RecentLabel)
        
        configView()
        configData()
        configTableView()
        
    }
    func configView(){
        paypalView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paypalView.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingRight: 25, height: 75)
        
        paypalView.addSubview(PaypalLabel)
 
        PaypalLabel.centerYAnchor.constraint(equalTo: paypalView.centerYAnchor).isActive = true
        PaypalLabel.centerXAnchor.constraint(equalTo: paypalView.centerXAnchor).isActive = true
        PaypalLabel.anchor(paddingTop: 0)
        
        debitView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        debitView.anchor(top: paypalView.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 25, paddingRight: 25, height: 75)
        
        debitView.addSubview(DebitLabel)
 
        DebitLabel.centerYAnchor.constraint(equalTo: debitView.centerYAnchor).isActive = true
        DebitLabel.centerXAnchor.constraint(equalTo: debitView.centerXAnchor).isActive = true
        DebitLabel.anchor(paddingTop: 0)
        
        RecentLabel.anchor(top: debitView.bottomAnchor, left: view.leftAnchor, paddingTop: 25, paddingLeft: 15)
    }
    
    func configTableView()
    {
        view.addSubview(tableview)
        
        tableview.register(TransactionCell.self, forCellReuseIdentifier: cellid)
        
        tableview.rowHeight = 60
        tableview.separatorStyle = .none
        tableview.showsVerticalScrollIndicator = false
        tableview.anchor(top: RecentLabel.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 5, width: view.width)
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    
    func configData(){
        let name = ["Amaruq D", "Thomas F"]
        let type = ["PayPal", "Debit Card"]
   
        for i in 0..<name.count {
            let transaction = BankModel(username: name[i], type: type[i])
            self.transactionData.append(transaction)
        }
    }
    
}

extension Transfer: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! TransactionCell
        
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
        
        let items = transactionData[indexPath.row]

        cell.NameLabel.text = items.username
        cell.TypeLabel.text = ""
        cell.AmountLabel.text = items.type
        cell.TimeLabel.text = ""
        
        return cell
    }
}


