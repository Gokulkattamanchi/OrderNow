//
//  ScannedProductDetailsViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 12/6/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import Foundation
import UIKit

class ScannedProductDetailsViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    @IBOutlet weak var enterProduct: UITextField!
    
    var productInfo: Product?
    var orderId: Int?
    override func viewWillAppear(_ animated: Bool) {
        
        let trimmedString = productInfo?.productName!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if trimmedString == "" {
            self.enterProduct.isHidden = false
            self.productName.isHidden = true
        }else {
            self.enterProduct.isHidden = true
            self.productName.isHidden = false
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enterProduct.delegate = self
        
        self.quantityStepper.wraps = true
        self.quantityStepper.autorepeat = true
        self.quantityStepper.maximumValue = 10
        self.quantityStepper.value = 1
        self.quantityStepper.minimumValue = 1
        self.quantity.text = "1"
        
        self.productName.text = productInfo?.productName
        self.productPrice.text = productInfo?.productPrice
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "free.png")!)


        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            
            return false
        }
        textField.resignFirstResponder()
        
        return true
    }

    
    @IBAction func stepperClicked(_ sender: UIStepper) {
        
        self.quantity.text = Int(sender.value).description
    }
    
    @IBAction func saveButtonClicked()
    {
        
        let trimmedString = productInfo?.productName!.trimmingCharacters(in: CharacterSet.whitespaces)

        if  (trimmedString == "")
        {
            
            if enterProduct.text == "" {
                
                let alertController = UIAlertController(title: "", message: "Please enter product name", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .destructive, handler:{ (action) in
                    
                })
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
                
            }

            enterProduct.resignFirstResponder()
            
            print("no product name1")
            productInfo?.productName = self.enterProduct.text
            productInfo?.quantity = self.quantity.text
            FacadeLayer.sharedInstance.updateProductsInOrder(productInfo!, orderId: orderId!, completionHandler: { (status) in
                if status {
                    print("non barcoded Product Saved to Orders")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "DismissChildAndBarcodeController"), object: nil)
                }
            })
        }
        else{
        productInfo?.quantity = self.quantity.text
        FacadeLayer.sharedInstance.updateProductsInOrder(productInfo!, orderId: orderId!, completionHandler: { (status) in
            if status {
                print("Product Saved to Orders")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "DismissChildAndBarcodeController"), object: nil)
            }
        })
        }
    }
    
    
    @IBAction func cancelButtonClicked() {
        
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DismissChildController"), object: nil)
    }
    
}
