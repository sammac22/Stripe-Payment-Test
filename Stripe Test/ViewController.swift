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
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var planNameField: UITextField!
    @IBOutlet weak var planPricingField: UITextField!
    
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
    //{ result in
//        switch result {
//
//        case .success:
//            completion(nil)
//
//            let alertController = UIAlertController(title: "Congrats",
//                                                    message: "Created plan!",
//                                                    preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
//                self.navigationController?.popViewController(animated: true)
//            })
//            alertController.addAction(alertAction)
//            self.present(alertController, animated: true)
//
//        case .failure(let error):
//            completion(error)
//        }
//    }

        // Not really sure how to do error handling here
    print("Created plan")
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
