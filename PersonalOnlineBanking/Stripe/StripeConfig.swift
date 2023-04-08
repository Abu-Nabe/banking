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
        config.publishableKey = "pk_test_51M5o3IGWslu84Leou5Mvu4ISGxHaLIUAabIEDKs6m1x0MhVoMzQgiTj5G5OjLMoX5RT4vTuRzGghsqhrzcZbLErh00rF9gztkO"
    }
}
