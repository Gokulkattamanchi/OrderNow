//
//  firstViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/22/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit
class firstViewController: UIViewController {
    
    @IBOutlet weak var createView: UIView!
    
    @IBOutlet weak var ordersView: UIView!
    
    @IBOutlet weak var notesView: UIView!
    
   // @IBOutlet weak var invoiceVIew: UIView!
    
        //self.navigationItem.leftBarButtonItem!.enabled = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;

       // [navigationController setNavigationBarHidden: YES animated:YES]
        createView.userInteractionEnabled = true
        ordersView.userInteractionEnabled = true
        notesView.userInteractionEnabled = true
       // invoiceVIew.userInteractionEnabled = true
        //error in view segue
        
        let create_guester = UITapGestureRecognizer(target: self, action: #selector(firstViewController.create_order_view) )
        let view_orders_guester = UITapGestureRecognizer(target: self, action: #selector(firstViewController.view_orders_view) )
        let notes_guester = UITapGestureRecognizer(target: self, action: #selector(firstViewController.notes_view) )
       // let invoice_guester = UITapGestureRecognizer(target: self, action: #selector(firstViewController.invoice_view) )
        
        
        
        self.createView.addGestureRecognizer(create_guester)
        self.ordersView.addGestureRecognizer(view_orders_guester)
        self.notesView.addGestureRecognizer(notes_guester)
       // self.invoiceVIew.addGestureRecognizer(invoice_guester)
    }
    
    
    func create_order_view(sender: UITapGestureRecognizer)  {
        
        performSegueWithIdentifier("orderSegue", sender: self)
    }
    
    func view_orders_view(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("orders_segue", sender: self)
    }
    func notes_view(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("notes_segue", sender: self)
    }
 //   func invoice_view(sender: UITapGestureRecognizer) {
   //     performSegueWithIdentifier("invoice_segue", sender: self)
   // }
    
  
    

}

