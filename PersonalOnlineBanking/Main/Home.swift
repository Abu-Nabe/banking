//
//  Home.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 4/4/2023.
//

import UIKit
import SQLite3
import Stripe

class Home: UIViewController{
    
    let cellid = "cellid"
    var transactionData: [TransactionModel] = [TransactionModel]()
    var cardData: [CardModel] = [CardModel]()
    
    let WelcomeView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let LineView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let CurvedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Basic2")
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "Gray2")!.cgColor
        return view
    }()
    
    let cardView: CardView = {
        let view = CardView()
        
        return view
    }()
    
    let cardImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "mastercard_logo")
       return image
    }()
    
    private let WelcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome, Ibraheem"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24.0)
        label.textColor = .white
        return label
    }()
    
    private let RecentLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Transactions"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24.0)
        label.textColor = UIColor(named: "Basic")
        
        return label
    }()
    
    private let NumberLabel: UILabel = {
        let label = UILabel()
        label.text = "**** **** **** 0000"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .white
        return label
    }()
    
    private let CardLabel: UILabel = {
        let label = UILabel()
        label.text = "VISA"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    private let ExpiryLabel: UILabel = {
        let label = UILabel()
        label.text = "00/00"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    private let tableview: UITableView =
    {
        let tableview = UITableView()
            
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(WelcomeView)
        view.addSubview(WelcomeLabel)
        view.addSubview(LineView)
        view.addSubview(cardView)
        view.addSubview(cardImageView)
        view.addSubview(CurvedView)
        view.addSubview(RecentLabel)
        
        config()
        configTableView()
            
        StripeConfig.config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configData()
    }
    
    func config(){
        WelcomeView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.height/3)
        
        WelcomeView.backgroundColor = HexColor(hex: "#1434A4")
        
        LineView.anchor(bottom: WelcomeView.bottomAnchor,width: view.width, height: 1)
        
        WelcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 15)
        
        cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardView.centerYAnchor.constraint(equalTo: LineView.centerYAnchor).isActive = true
        cardView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 25, paddingRight: 25, height: 200)
        
        cardView.addSubview(CardLabel)
        cardView.addSubview(ExpiryLabel)
        cardView.addSubview(cardImageView)
        cardView.addSubview(NumberLabel)
        
        NumberLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        NumberLabel.anchor(left: cardView.leftAnchor, paddingLeft: 20)
       
        CardLabel.anchor(bottom: cardView.bottomAnchor, right: cardView.rightAnchor, paddingBottom: 20, paddingRight: 20)
        
        ExpiryLabel.anchor(left: cardView.leftAnchor, bottom: cardView.bottomAnchor, paddingLeft: 20, paddingBottom: 20)
        
        cardImageView.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, paddingTop: 5, paddingLeft: 5, width: 80, height: 80)
        
        RecentLabel.anchor(top: cardView.bottomAnchor, left: view.leftAnchor, paddingTop: 25, paddingLeft: 15)
        
        CurvedView.anchor(top: RecentLabel.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 10)
    }
    
    func configTableView()
    {
        CurvedView.addSubview(tableview)
        
        tableview.register(TransactionCell.self, forCellReuseIdentifier: cellid)
        
        tableview.rowHeight = 60
        tableview.separatorStyle = .none
        tableview.showsVerticalScrollIndicator = false
        tableview.anchor(top: CurvedView.topAnchor, bottom: CurvedView.bottomAnchor, paddingTop: 5, width: view.width)
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func configData(){
        transactionData = SQLiteTransaction.getTransactions()
        
        cardData = SQLiteCard.getCards()
        configCard()
    }
    
    func configCard(){
        NumberLabel.text = "**** **** **** " + cardData[0].last4
        ExpiryLabel.text = cardData[0].expiry
        CardLabel.text = cardData[0].type
      
        let cardBrand = CardType.reverseConfig(from: cardData[0].type)
        cardView.backgroundColor = cardBrand
    
    }
}

extension Home: UITableViewDelegate, UITableViewDataSource
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
        cell.TypeLabel.text = items.type
        cell.AmountLabel.text = items.amount
        cell.TimeLabel.text = items.time
        
        return cell
    }
}


