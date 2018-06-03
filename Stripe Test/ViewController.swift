//
//  ViewController.swift
//  Stripe Test
//
//  Created by Sam MacGinty on 02/06/2018.
//  Copyright © 2018 Sam MacGinty. All rights reserved.
//

import UIKit
import Stripe

class ViewController: UIViewController {

    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var customerButton: UIButton!
    @IBOutlet weak var customerField: UITextField!
    @IBOutlet weak var customerIDField: UITextField!
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var planNameField: UITextField!
    @IBOutlet weak var planPricingField: UITextField!
    @IBOutlet weak var createSubscriptionButton: UIButton!
    @IBOutlet weak var subscriptionCustomerIDField: UITextField!
    @IBOutlet weak var planIDField: UITextField!
    @IBOutlet weak var useQuanityField: UITextField!
    @IBOutlet weak var subscriptionIDField: UITextField!
    @IBOutlet weak var recordUseButton: UIButton!
    
    //    @IBAction func paidTapped(_ sender: Any) {
//        print("tap registered")
//
//        let addCardViewController = STPAddCardViewController()
//        addCardViewController.delegate = self
//        let navigationController = UINavigationController(rootViewController: addCardViewController)
//        present(navigationController, animated: true)
//    }

    @IBAction func customerTapped(_ sender: Any) {
        print("tap registered")
        
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }

    @IBAction func planTapped(_ sender: Any) {
        print("Tap registered")
        
        let price_per_unit = Double(planPricingField.text!)!
        let plan_name = planNameField.text!
        createPlan(price_per_unit:price_per_unit, plan_name:plan_name)
    }

    @IBAction func createSubscriptionTapped(_ sender: Any) {
        print("Tap registered")
        
        let customer_id = subscriptionCustomerIDField.text!
        let plan_id = planIDField.text!
        createSubscription(customer_id: customer_id, plan_id: plan_id)
    }
    
    @IBAction func recordUseTapped(_ sender: Any) {
        print("Tap registered")
        
        let quanity = Int(useQuanityField.text!)
        let subscription_id = subscriptionIDField.text!
        
        print(String(quanity!))
        createUsageRecord(quanity: quanity!, subscripiton_id: subscription_id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

func createPlan(price_per_unit: Double, plan_name: String){

    StripeClient.shared.createPlan(amount:price_per_unit, product:plan_name)

    // Not really sure how to do error handling here
    
    print("Created plan")
}

func createSubscription(customer_id: String, plan_id: String){
    
    StripeClient.shared.createSubscription(customer: customer_id, plan: plan_id)
    
    // Not really sure how to do error handling here
    
    print("Created subscription")
}

func createUsageRecord(quanity: Int, subscripiton_id: String){
    
    StripeClient.shared.createUsageRecord(quanity: quanity, subscription_item: subscripiton_id)
    
    // Not really sure how to do error handling here
    
    print("Created usage record")
}

extension ViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
//    func addCardViewController(_ addCardViewController: STPAddCardViewController,
//                               didCreateToken token: STPToken,
//                               completion: @escaping STPErrorBlock) {
//        let total = Int(amountField.text!)
//        StripeClient.shared.completeCharge(with: token, amount: total!) { result in
//            switch result {
//
//            case .success:
//                completion(nil)
//
//                let alertController = UIAlertController(title: "Congrats",
//                                                        message: "Your payment was successful!",
//                                                        preferredStyle: .alert)
//                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
//                    self.navigationController?.popViewController(animated: true)
//                })
//                alertController.addAction(alertAction)
//                self.present(alertController, animated: true)
//
//            case .failure(let error):
//                completion(error)
//            }
//        }
//
//    }
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                                              didCreateToken token: STPToken,
                                              completion: @escaping STPErrorBlock) {
        let description = customerField.text!
        StripeClient.shared.addCustomer(with: token, customer_description: description) { result in
            
            switch result {
                
            case .success:
                completion(nil)
                
                let alertController = UIAlertController(title: "Congrats",
                                                        message: "Added customer!",
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
                
            case .failure(let error):
                completion(error)
            }
        }
    }
}
