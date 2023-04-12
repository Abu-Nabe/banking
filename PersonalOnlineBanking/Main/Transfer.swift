//
//  Transfer.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 4/4/2023.
//

import UIKit
import Stripe
import StripePaymentSheet

class Transfer: UIViewController{
    
    var paymentSheet: PaymentSheet?
    var StripeUrl = url_connect.url + "payment/" + "StripePayment.php"
    
    var cardData: [CardModel] = [CardModel]()
    
    let cellid = "cellid"
    var transactionData: [BankModel] = [BankModel]()
    
    var CurrencyArrays = CurrencyArray.Currency
    var CurrencyType = "USD"
    
    var paypalToken = ""
    var ready = false
    let paypalView: CardView = {
        let view = CardView()
        view.backgroundColor = UIColor(named: "Basic2")
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "Gray2")!.cgColor
        return view
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.layer.borderWidth = 2
        field.returnKeyType = .next
        field.layer.cornerRadius = 16
        field.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        field.backgroundColor = UIColor(named: "Basic2")
        field.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        field.clipsToBounds = true
        field.tintColor = UIColor(named: "Basic")
        
        return field
    }()
    
    private let Button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.setTitle("USD", for: .normal)
        button.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = HexColor(hex: "#6495ED")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return button
    }()
    
    private let coinField: UITextField = {
        let field = UITextField()
        field.placeholder = "10.00"
        field.layer.borderWidth = 2
        field.textAlignment = .center
        field.returnKeyType = .next
        field.layer.cornerRadius = 8
        field.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        field.backgroundColor = UIColor(named: "Basic2")
        field.clipsToBounds = true
        field.tintColor = UIColor(named: "Basic")
        field.keyboardType = .decimalPad
        
        return field
    }()
    
    private let PaypalLabel: UILabel = {
        let label = UILabel()
        label.text = "Transfer to Paypal"
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
    
    var pickerView = UIPickerView()
    
    let toolbarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Gray2")
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pickerView)
        view.addSubview(paypalView)
        view.addSubview(Button)
        view.addSubview(emailField)
        view.addSubview(RecentLabel)
        view.addSubview(toolbarView)
        view.addSubview(coinField)
    
        configView()
        configTap()
        configTableView()
        configToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PaypalLabel.text = "Transfer to PayPal"
    }
    
    func configureStripe(coinString: String)
    {
        // MARK: Fetch the PaymentIntent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var components = URLComponents(url: URL(string: StripeUrl)!, resolvingAgainstBaseURL: false)!

        components.queryItems = [
            URLQueryItem(name: "price", value: coinString),
            URLQueryItem(name: "currency", value: CurrencyType)
        ]

        let query = components.url!.query
        
        var request = URLRequest(url: URL(string: StripeUrl)!)
        request.httpMethod = "POST"
        request.httpBody = Data(query!.utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let customerId = json["customer"] as? String,
                  let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                  let paymentIntentClientSecret = json["paymentIntent"] as? String,
                  let publishableKey = json["publishableKey"] as? String,
                  let self = self else {
                print("XAS", response)
                // Handle error
                return
            }
            
                STPAPIClient.shared.publishableKey = StripeConfig.publishableKey
              // MARK: Create a PaymentSheet instance
              var configuration = PaymentSheet.Configuration()
              configuration.merchantDisplayName = "Example, Inc."
              configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
              // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
              // methods that complete payment after a delay, like SEPA Debit and Sofort.
              configuration.allowsDelayedPaymentMethods = true
              self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)

              DispatchQueue.main.async {
                  self.goCheckOut()
              }
            })
            task.resume()
    }
    
    func configView(){
        emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: Button.leftAnchor, paddingTop: 25, paddingLeft: 25, paddingRight: 5, height: 45)
        Button.anchor(top: emailField.topAnchor, bottom: emailField.bottomAnchor, right: view.rightAnchor, paddingRight: 25, width: 45)
        
        coinField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coinField.anchor(top: emailField.bottomAnchor, paddingTop: 10, width: 100, height: 30)
        
        paypalView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paypalView.anchor(top: coinField.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingRight: 25, height: 75)
        
        paypalView.addSubview(PaypalLabel)
        
        PaypalLabel.centerYAnchor.constraint(equalTo: paypalView.centerYAnchor).isActive = true
        PaypalLabel.centerXAnchor.constraint(equalTo: paypalView.centerXAnchor).isActive = true
        PaypalLabel.anchor(paddingTop: 0)
        
        RecentLabel.anchor(top: paypalView.bottomAnchor, left: view.leftAnchor, paddingTop: 25, paddingLeft: 15)
        
        pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, width: view.width, height: 300)
        
        toolbarView.anchor(left: view.leftAnchor, bottom: pickerView.topAnchor, right: view.rightAnchor, height: 45)
        
        coinField.delegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
    }
    
    func configToolbar(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
        toolbar.tintColor = .systemBlue
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        
        toolbarView.addSubview(toolbar)
    }
    
    func configTap(){
        let paypalTap = UITapGestureRecognizer(target: self, action: #selector(transferPaypal))
        paypalView.addGestureRecognizer(paypalTap)
        
        let currencyTap = UITapGestureRecognizer(target: self, action: #selector(changeCurrency))
        Button.addGestureRecognizer(currencyTap)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @objc func transferPaypal(){
        let emailString = emailField.text!.replacingOccurrences(of: " ", with: "")
        
        var coinString = coinField.text!.replacingOccurrences(of: " ", with: "")
        coinString = coinString.replacingOccurrences(of: ".", with: "")
       
        if(!emailString.isEmpty && !coinString.isEmpty){
            PaypalLabel.text = "Configuring"
            configureStripe(coinString: coinString)
        }else{
            if(emailString.isEmpty){
                emailField.layer.borderColor = UIColor(named: "Red")?.cgColor
            }else{
                coinField.layer.borderColor = UIColor(named: "Red")?.cgColor
            }
        }
    }
       
    @objc func goCheckOut() {
      // MARK: Start the checkout process
        paymentSheet?.present(from: self) { [self] paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
                PaypalLabel.text = "Transfer To PayPal"
                print("XAS","Your order is confirmed")
            case .canceled:
                PaypalLabel.text = "Transfer To PayPal"
                print("XAS","Canceled!")
            case .failed(let error):
                PaypalLabel.text = "Transfer To PayPal"
                print("XAS","Payment failed: \(error)")
            }
        }
    }
    
    @objc func changeCurrency(){
        tableview.isHidden = true
        
        pickerView.isHidden = false
        toolbarView.isHidden = false
    }
    
    @objc func doneButtonTapped() {
        tableview.isHidden = false
        
        pickerView.isHidden = true
        toolbarView.isHidden = true
        
        CurrencyType = (Button.titleLabel?.text)!
    }
    
    @objc func cancelButtonTapped() {
        tableview.isHidden = false
        
        pickerView.isHidden = true
        toolbarView.isHidden = true
        Button.setTitle(CurrencyType, for: .normal)
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
        transactionData = SQLiteBank.retrieveBankData()
    }
    
}

extension Transfer: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == coinField {
            if let text = textField.text, let amount = Double(text) {
                textField.text = String(format: "%.2f", amount)
            }
        }
        paypalView.isUserInteractionEnabled = true
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        paypalView.isUserInteractionEnabled = false
        
        return true
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

extension Transfer: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return CurrencyArrays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CurrencyArrays[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row < CurrencyArrays.count else {
            return
        }
        let currencySelected = CurrencyArrays[row]
        
        Button.setTitle(currencySelected, for: .normal)
        
    }
}
