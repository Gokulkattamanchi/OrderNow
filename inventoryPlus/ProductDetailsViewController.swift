//
//  ProductDetailsViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 12/1/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit
import MessageUI
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class ProductDetailsViewController: UIViewController, BarCodeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var productDetailsTableView: UITableView!
    
    var orderInfo: OrderInfo?
    var productArray: [Product]?
    
    override func viewDidLoad() {
        
//        let navItem = UINavigationItem(title: "Scan");
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: nil, action: Selector("selector"));
//        navItem.rightBarButtonItem = doneItem;
//        self.navigationController?.navigationBar.setItems([navItem], animated: false);
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "free.png")!)
        self.productDetailsTableView.backgroundColor = UIColor.clear
        

        if orderInfo?.productDetails?.count > 0 {
            self.productArray = orderInfo!.productDetails
            self.productDetailsTableView.delegate = self
            self.productDetailsTableView.dataSource = self
            self.productDetailsTableView.reloadData()
        }
    }
    
    
    func barcodeViewControllerDismissed() {
        self.dismiss(animated: true, completion: nil)
        if let orderId = orderInfo?.orderId {
        
            FacadeLayer.sharedInstance.fetchProductsInOrder(orderId, completionHandler: { (products, status) in
                if status {
                    self.productArray = products
                    self.productDetailsTableView.delegate = self
                    self.productDetailsTableView.dataSource = self
                    self.productDetailsTableView.reloadData()
                }
            })
        }

    }
//    func saveInstructions(sender:AnyObject)
//    {
//       // var savePath = filD
//        var fileName = "filters.text"
//        var fileAtPath = savePath.path?.stringByAppendingPathComponent(fileName)
//        if(NSFileManager.defaultManager().fileExistsAtPath(fileAtPath!) == false)
//        {
//            NSFileManager.defaultManager().createFileAtPath(fileAtPath!, contents: nil, attributes: nil)
//        }
//        var fileHandle:NSFileHandle = NSFileHandle(forWritingAtPath: fileAtPath!)!
//        fileHandle.seekToEndOfFile()
//        fileHandle.writeData("text".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
//        
//    }
    
    @IBAction func shareButtonClicked(_ sender: AnyObject) {
        
        if productArray?.count > 0 {
            
            var productData = ""
            
            for i in 0 ..< productArray!.count {
                let productdetail = productArray![i]
                productData = productData + "Name:" + productdetail.productName! + "\n" + "Quantity:" + productdetail.quantity! + "\n"
            }
            
            //        for i in 0 ..< count {
            //            csv += String(format: "\n\"%@\",%@,\"%d\"", firstArray[i],secondArray[i],1)
            //        }
            
            let fileName = "Products"
            
            let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
            print("FilePath: \(fileURL.path)")
            
            do{
                try productData.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
            
            var readStringProject = ""
            do {
                readStringProject = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
            } catch let error as NSError {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
            print(readStringProject)
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setSubject("Products")
            if let fileData = try? Data(contentsOf: fileURL) {
                mailComposerVC.addAttachmentData(fileData, mimeType: "text/txt", fileName: "Products")
            }
            //        mailComposerVC.setMessageBody(beaconData, isHTML: false)
            self.present(mailComposerVC, animated: true, completion: nil)
            
        }
        
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print(error?.localizedDescription)
        switch (result) {
        case MFMailComposeResult.sent:
            print("sent")
        case MFMailComposeResult.saved:
            print("saved")
        case MFMailComposeResult.cancelled:
            print("cancelled")
        case MFMailComposeResult.failed:
            print("failed")
        default:
            print("default")
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addNewProductClicked(_ sender: AnyObject) {
        
        let barcodeVC = self.storyboard?.instantiateViewController(withIdentifier: "BarCodeViewController") as! BarCodeViewController
        barcodeVC.orderInfo = orderInfo
        barcodeVC.delegate = self
        self.present(barcodeVC, animated: true, completion: nil)

    }
    
}

extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.productArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsTableViewCell", for: indexPath) as! ProductDetailsTableViewCell
        let productInfo = self.productArray![indexPath.row]
        cell.productNamelbl?.text = productInfo.productName
        cell.productQuantitylbl.text = productInfo.quantity
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        
        
    }
//     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            //self.productArray![indexPath.row].delete()
//            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            //let moc = appDelegate.managedObjectContext // or something similar to get the managed object context
//            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//            //moc.delete(data)  // your NSManagedObject
////            var myData: Array<AnyObject> = []
////            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
////            // 2
////            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
////            let context:NSManagedObjectContext = appDel.managedObjectContext
////            context.deleteObject(myData[indexPath.row] )
////            myData.removeAtIndex(indexPath.row)
////            do {
////                try context.save()
////            } catch _ {
////            }
////            
////            // remove the deleted item from the `UITableView`
////            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
////            default:
//            return
//            let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
//            managedObjectContext?.deleteObject(managedObject)
//            managedObjectContext?.save(nil)
//        }
//
//        }
//    }
//    
//     func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        let tmpNote = notes[sourceIndexPath.row]
//        notes.removeAtIndex(sourceIndexPath.row)
//        notes.insert(tmpNote, atIndex: destinationIndexPath.row)
//        }
//    

    
    
}
