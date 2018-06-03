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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
