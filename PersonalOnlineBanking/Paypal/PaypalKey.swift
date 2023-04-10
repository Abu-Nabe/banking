//
//  PaypalKey.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 9/4/2023.
//

import UIKit
import Alamofire
class PaypalKey{
    static func getPaypalToken(completion: @escaping (Result<String, Error>) -> Void) {
        let url_connect1 = url_connect.url + "payment/" + "PaypalToken.php"

        AF.request(url_connect1, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseString { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
