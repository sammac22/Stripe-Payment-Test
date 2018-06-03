//
//  StripeClient.swift
//  Stripe Test
//
//  Created by Sam MacGinty on 02/06/2018.
//  Copyright © 2018 Sam MacGinty. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

enum Result {
    case success
    case failure(Error)
}

final class StripeClient {
    
    static let shared = StripeClient()
    
    private init() {
        // private
    }
    
    private lazy var baseURL: URL = {
        guard let url = URL(string: Constants.baseURLString) else {
            fatalError("Invalid URL")
        }
        return url
    }()
    
    func completeCharge(with token: STPToken, amount: Int, completion: @escaping (Result) -> Void) {
        // 1
        let url = baseURL.appendingPathComponent("charge")
        // 2
        let params: [String: Any] = [
            "token": token.tokenId,
            "amount": amount,
            "currency": Constants.defaultCurrency,
            "description": Constants.defaultDescription
        ]
        // 3
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(Result.success)
                case .failure(let error):
                    completion(Result.failure(error))
                }
        }
    }
    
    func addCustomer(with token: STPToken, customer_description: String, email: String, completion: @escaping (Result) -> Void){
        
        let url = baseURL.appendingPathComponent("customers")
        
        let params: [String: Any] = [
            "description": customer_description,
            "email": email,
            "token": token.tokenId
        ]
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString{ response in
                let result = response.result
                switch result {
                case .success:
                    completion(Result.success)
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
//            .responseJSON{ response in
//               let result = response.result
//                print("Made it here 1")
//                if let dict = result.value as? Dictionary<String, AnyObject> {
//                    print("Made it here 2")
//                    print(dict)
//                }
//                let dict = result.value as? Dictionary<String, AnyObject>
//                print(dict as Any)
//        }
        
        
    }
    
    func createPlan(amount: Double, product: String){
        
        let url = baseURL.appendingPathComponent("plans")
        
        let currency = Constants.defaultCurrency
        let interval = Constants.defaultInterval
        let usage_type = "metered"
        
        let int_amount = Int(amount * 100)
        
        let params: [String: Any] = [
            "currency": currency,
            "interval": interval,
            "product": product,
            "amount": int_amount,
            "usage_type": usage_type
        ]
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
        
    }
    
    func createSubscription(customer: String, plan: String){
        
        let url = baseURL.appendingPathComponent("subscriptions")
        
        let params: [String: Any] = [
            "customer": customer,
            "plan": plan,
        ]
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
    }
    
    func createUsageRecord(quantity: Int, subscription_item: String){
        
        let url = baseURL.appendingPathComponent("usage_records")
        
        let timestamp = String(Int(NSDate().timeIntervalSince1970))
        
        let params: [String: Any] = [
            "quantity": quantity,
            "timestamp": timestamp,
            "subscription_item": subscription_item
            ]
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
    }
    
    
    
}

