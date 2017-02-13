//
//  emailViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/24/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//
import Foundation
import UIKit
import MessageUI

class emailViewController: UIViewController,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var bodytext: UITextView!
    @IBOutlet weak var subjectText: UITextField!
     @IBAction func sendEmail(sender: AnyObject)  {
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(subjectText.text!)
        mailCompose.setMessageBody(bodytext.text, isHTML: true)
        
        presentViewController(mailCompose, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "free.png")!)

        subjectText.delegate = self
        bodytext.delegate = self
    }
    
//    func configuredMailComposeViewController() -> MFMailComposeViewController {
//        let mailComposerVC = MFMailComposeViewController()
//        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
//        
//        mailComposerVC.setToRecipients(["nurdin@gmail.com"])
//        mailComposerVC.setSubject("Sending you an in-app e-mail...")
//        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
//        self.presentViewController(mailComposerVC, animated: true, completion: nil)
//        return mailComposerVC
//    }
    
//    func showSendMailErrorAlert() {
//        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//        sendMailErrorAlert.show()
//    }
    
    // MARK: MFMailComposeViewControllerDelegate

    // 1
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // UITextFieldDelegate
    
    // 2
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // UITextViewDelegate
    
    // 3
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        bodytext.text = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
}
    
