//
//  StripeConfig.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 6/4/2023.
//

import UIKit
import Stripe

class StripeConfig{
    static func config(){
        let config = STPPaymentConfiguration.shared
        config.publishableKey = // removed
    }
}
