//
//  CardType.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 8/4/2023.
//

import UIKit
import Stripe

class CardType{
    static func config(cardBrand: STPCardBrand) -> String {
        switch cardBrand {
        case .visa:
            return "Visa"
        case .mastercard:
            return "Mastercard"
        case .amex:
            return "American Express"
        case .discover:
            return "Discover"
        default:
            return "Unknown"
        }
    }
    
    static func reverseConfig(from string: String) -> UIColor {
            switch string.lowercased() {
            case "visa":
                return HexColor(hex: "#6495ED")
                
            case "mastercard":
                return HexColor(hex: "#D70040")
                
            case "amex", "american express":
                return HexColor(hex: "#50C878")
                
            case "discover":
                return HexColor(hex: "#5D3FD3")
                
            default:
                return HexColor(hex: "#36454F")
            }
        }
}
