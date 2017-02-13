//
//  orderNameViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/29/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit
import GoogleMobileAds
class orderNameViewController: UIViewController,UITextFieldDelegate, GADBannerViewDelegate
{
    @IBOutlet weak var orderNametext: UITextField!
    @IBOutlet var bannerView: GADBannerView!
    @IBAction func cancelButton(_ sender: AnyObject) {
        
        //self.navigationController?.popViewControllerAnimated(true);
        self.dismiss(animated: true, completion: {});
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        orderNametext.delegate = self
         self.view.backgroundColor = UIColor(patternImage: UIImage(named: "free.png")!)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
       // bannerView.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
        bannerView.delegate = self
        bannerView.adUnitID = "*******************" //enter admob app id
        bannerView.rootViewController = self
        bannerView.load(request)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(orderNameViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            
            return false
        }
        textField.resignFirstResponder()
        
        return true
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
  
    @IBAction func createOrderClicked(){
        
        orderNametext.resignFirstResponder()
        
        if orderNametext.text == "" {
            
            let alertController = UIAlertController(title: "", message: "Please enter order name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .destructive, handler:{ (action) in
                
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
        let orderId = Int(arc4random_uniform(1000))
        
        FacadeLayer.sharedInstance.saveOrderInfo(orderId, orderName: orderNametext.text!) { (status) in
            if status {
                print("Order has been saved successfully")
                self.dismiss(animated: true, completion: nil);
            }
        }
        
    }


}
