//
//  Payment.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 4/4/2023.
//

import UIKit
import Stripe

class Payment: UIViewController{
    
    let paypalView: CardView = {
        let view = CardView()
        view.backgroundColor = HexColor(hex: "#3b7bbf")
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "Gray2")!.cgColor
        return view
    }()
    
    let debitView: CardView = {
        let view = CardView()
        view.backgroundColor = HexColor(hex: "#D2042D")
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "Gray2")!.cgColor
        return view
    }()
    
    let applePayView: CardView = {
        let view = CardView()
        view.backgroundColor = HexColor(hex: "#000000")
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "Gray2")!.cgColor
        return view
    }()
    
    let googlePayView: CardView = {
        let view = CardView()
        view.backgroundColor = HexColor(hex: "#4285F4")
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "Gray2")!.cgColor
        return view
    }()
    
    let giftcardView: CardView = {
        let view = CardView()
        view.backgroundColor = HexColor(hex: "#FFAA33")
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "Gray2")!.cgColor
        return view
    }()
    
    private let PaypalLabel: UILabel = {
        let label = UILabel()
        label.text = "Add PayPal account"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    private let DebitLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a card"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    private let AppleLabel: UILabel = {
        let label = UILabel()
        label.text = "Configure Apple Pay"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    private let GoogleLabel: UILabel = {
        let label = UILabel()
        label.text = "Configure Google Pay"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    private let GiftCardLabel: UILabel = {
        let label = UILabel()
        label.text = "Giftcard Code"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    
    let paypalImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "paypal_logo")
       return image
    }()
    
    let debitImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "mastercard_logo")
       return image
    }()
    
    let appleImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "apple_logo")
       return image
    }()
    
    let googleImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "google_icon")
       return image
    }()
    
    let giftcardImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "gift.fill")
        image.tintColor = .systemPink
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(paypalView)
        view.addSubview(debitView)
        view.addSubview(applePayView)
        view.addSubview(googlePayView)
        view.addSubview(giftcardView)
        
        config()
        configOnClick()
    }
    
    func config(){
        paypalView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paypalView.anchor(left: view.leftAnchor, bottom: debitView.topAnchor, right: view.rightAnchor, paddingLeft: 25, paddingBottom: 10, paddingRight: 25, height: 100)
        
        paypalView.addSubview(PaypalLabel)
        paypalView.addSubview(paypalImageView)
        
        PaypalLabel.centerYAnchor.constraint(equalTo: paypalView.centerYAnchor).isActive = true
        PaypalLabel.centerXAnchor.constraint(equalTo: paypalView.centerXAnchor).isActive = true
        PaypalLabel.anchor(paddingTop: 0)
        
        paypalImageView.centerYAnchor.constraint(equalTo: paypalView.centerYAnchor).isActive = true
        paypalImageView.anchor(left: paypalView.leftAnchor, paddingLeft: 25, width: 50, height: 30)
        
        debitView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        debitView.anchor(left: view.leftAnchor, bottom: applePayView.topAnchor, right: view.rightAnchor, paddingLeft: 25, paddingBottom: 10, paddingRight: 25, height: 100)
        
        debitView.addSubview(DebitLabel)
        debitView.addSubview(debitImageView)
        
        DebitLabel.centerYAnchor.constraint(equalTo: debitView.centerYAnchor).isActive = true
        DebitLabel.centerXAnchor.constraint(equalTo: debitView.centerXAnchor).isActive = true
        DebitLabel.anchor(paddingTop: 0)
        
        debitImageView.centerYAnchor.constraint(equalTo: DebitLabel.centerYAnchor).isActive = true
        debitImageView.anchor(left: paypalView.leftAnchor, paddingLeft: 25, width: 50, height: 50)
        
        applePayView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        applePayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        applePayView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 25, paddingRight: 25, height: 100)
        
        applePayView.addSubview(AppleLabel)
        applePayView.addSubview(appleImageView)
        
        AppleLabel.centerYAnchor.constraint(equalTo: applePayView.centerYAnchor).isActive = true
        AppleLabel.centerXAnchor.constraint(equalTo: applePayView.centerXAnchor).isActive = true
        AppleLabel.anchor(paddingTop: 0)
        
        appleImageView.centerYAnchor.constraint(equalTo: applePayView.centerYAnchor).isActive = true
        appleImageView.anchor(left: applePayView.leftAnchor, paddingLeft: 30, width: 30, height: 30)
        
        
        googlePayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googlePayView.anchor(top: applePayView.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 25, paddingRight: 25, height: 100)
        
        googlePayView.addSubview(GoogleLabel)
        googlePayView.addSubview(googleImageView)
        
        GoogleLabel.centerYAnchor.constraint(equalTo: googlePayView.centerYAnchor).isActive = true
        GoogleLabel.centerXAnchor.constraint(equalTo: googlePayView.centerXAnchor).isActive = true
        GoogleLabel.anchor(paddingTop: 0)
        
        googleImageView.centerYAnchor.constraint(equalTo: googlePayView.centerYAnchor).isActive = true
        googleImageView.anchor(left: applePayView.leftAnchor, paddingLeft: 30, width: 30, height: 30)
        
        giftcardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        giftcardView.anchor(top: googlePayView.bottomAnchor,left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 25, paddingRight: 25, height: 100)
        
        giftcardView.addSubview(GiftCardLabel)
        giftcardView.addSubview(giftcardImageView)
        GiftCardLabel.centerYAnchor.constraint(equalTo: giftcardView.centerYAnchor).isActive = true
        GiftCardLabel.centerXAnchor.constraint(equalTo: giftcardView.centerXAnchor).isActive = true
        GiftCardLabel.anchor(paddingTop: 0)
        
        giftcardImageView.centerYAnchor.constraint(equalTo: GiftCardLabel.centerYAnchor).isActive = true
        giftcardImageView.anchor(left: applePayView.leftAnchor, paddingLeft: 30, width: 25, height: 25)
    }
    
    func configOnClick(){
        let cardData = SQLiteCard.getCards()
        
        if(cardData.count == 0){
            let debitTap = UITapGestureRecognizer(target: self, action: #selector(addCard))
            debitView.addGestureRecognizer(debitTap)
        }else{
            DebitLabel.text = "Card added"
        }
    }
    
    @objc func addCard(){
        let addCardViewController = STPAddCardViewController(configuration: STPPaymentConfiguration.shared, theme: STPTheme.defaultTheme)
        addCardViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
}

extension Payment: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        // Handle successful creation of payment method here
        let name = paymentMethod.billingDetails?.name ?? // removed
        let cardBrand = paymentMethod.card?.brand ?? .unknown
        let type = CardType.config(cardBrand: cardBrand)
        let last4 = paymentMethod.card?.last4 ?? ""
        let expMonth = paymentMethod.card?.expMonth ?? 0
        let expYear = paymentMethod.card?.expYear ?? 0
        let formattedExpDate = String(format: "%02d/%02d", expMonth, expYear % 100)
    
        print("Cardholder name: \(name)")
        print("Card brand: \(cardBrand.rawValue)")
        print("Last 4 digits: \(last4)")
        print("Expiration date: \(formattedExpDate)")
        
        SQLiteCard.insertCard(username: name, type: type, last4: last4, expdate: formattedExpDate)
        
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didFailToCreatePaymentMethodWithError error: Error) {
        // Handle error while creating payment method here
        print("XAS", error)
        dismiss(animated: true)
    }
    
    func setupCard(){
        
    }
}
