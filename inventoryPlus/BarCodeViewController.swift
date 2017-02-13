//
//  BarCodeViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 5/16/15.
//  Copyright © 2016 Monmouth University. All rights reserved.
//

import UIKit
import AVFoundation


protocol BarCodeViewControllerDelegate {

    func barcodeViewControllerDismissed()
}

class BarCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    /// Helper property and not directly used. The camera layer's bounds will be set to this.
    @IBOutlet weak var cameraView: UIView!
    /// Will show the type of metadata being displayed.
    @IBOutlet weak var lblDataType: UILabel!
    /// Will show the information from the capture metadata.
    @IBOutlet weak var lblDataInfo: UILabel!

    @IBAction func doneBarcde(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});

    }
    
    @IBOutlet weak var scannedProductDetailsContainerView: UIView!
    var delegate: BarCodeViewControllerDelegate?
    var orderInfo: OrderInfo?
    
    var productInfo: Product?
    var orderId: Int?
    let captureSession = AVCaptureSession()
    /// The device used as input for the capture session.
    var captureDevice:AVCaptureDevice?
    /// The UI layer to display the feed from the input source, in our case, the camera.
    var captureLayer:AVCaptureVideoPreviewLayer?
    
    //MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(childViewControllerDismissed), name: NSNotification.Name(rawValue: "DismissChildController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissBarcodeController), name: NSNotification.Name(rawValue: "DismissChildAndBarcodeController"), object: nil)


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DismissChildController"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "DismissChildAndBarcodeController"), object: nil)
    }
    
    func childViewControllerDismissed(){
        self.captureSession.startRunning()
    }
    
    func dismissBarcodeController(){
        self.delegate?.barcodeViewControllerDismissed()
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    //MARK: Session Startup
    /**
     Begins the capture session.
     */
    fileprivate func setupCaptureSession()
    {
        self.captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let deviceInput:AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(deviceInput)){
            // Show live feed
            captureSession.addInput(deviceInput)
            self.setupPreviewLayer({
                self.captureSession.startRunning()
                self.addMetaDataCaptureOutToSession()
            })
        } else {
            //  self.showError("Error while setting up input captureSession.")
        }
    }
    
    /**
     Handles setting up the UI to show the camera feed.
     
     - parameter completion: Completion handler to invoke if setting up the feed was successful.
     */
    fileprivate func setupPreviewLayer(_ completion:() -> ())
    {
        
        self.captureLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let capLayer = self.captureLayer {
            capLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            capLayer.frame = self.cameraView.frame
            self.view.layer.addSublayer(capLayer)
            completion()
        } else {
            //  self.showError("An error occured beginning video capture")
        }
    }
    
    
    //MARK: Metadata capture
    /**
     Handles identifying what kind of data output we want from the session, in our case, metadata and the available types of metadata.
     */
    fileprivate func addMetaDataCaptureOutToSession()
    {
        let metadata = AVCaptureMetadataOutput()
        self.captureSession.addOutput(metadata)
        metadata.metadataObjectTypes = metadata.availableMetadataObjectTypes
        metadata.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    }
    
    //MARK: Delegate Methods
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        
         var detectionString: String?
        
        if metadataObjects == nil || metadataObjects.count == 0
        {
            //qrCodeFrameView?.frame = CGRectZero
//            self.lblDataType.text = "No QR code is detected"
            return
        }
        
        let _: AVMetadataMachineReadableCodeObject?
        for metaData in metadataObjects
        {
            
            let decodedData:AVMetadataMachineReadableCodeObject = metaData as! AVMetadataMachineReadableCodeObject
//           self.lblDataInfo.text = decodedData.stringValue
             detectionString = decodedData.stringValue
            //self.lblDataType.text = decodedData.type
            
        }
        
        _ = 1
        _ = "E70704B0-8B27-41A6-ABD8-D09C76E4A41D"
        //   let upc = metadataObjects.stringValue
        if detectionString != nil {
            self.captureSession.stopRunning()
            self.getProductDetails(detectionString!)
        }
    }
    
    func getProductDetails(_ barcodeString: String) {
        
        
        let queryItems = [URLQueryItem(name: "request_type", value: "3"), URLQueryItem(name: "access_token", value: "Enter here access_token value after signing  from search upc"), URLQueryItem(name: "upc", value: String(barcodeString))]
        
        var urlComps = URLComponents(string: "http://www.searchupc.com/handlers/upcsearch.ashx?")!
        urlComps.queryItems = queryItems
        let URL = urlComps.url!
        // print(URL)
        
        var request = URLRequest(url:URL);
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                //print("error=\(error)")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                print(json)
                if let productsDetails = json? ["0"] as? [String:Any] {
                    
                        if let productName = productsDetails["productname"] as? String, let productPrice = productsDetails["price"] as? String, let productImageUrl = productsDetails["imageurl"] as? String {
                            let productInfo = Product(productName: productName, productPrice: productPrice, productImageUrl: productImageUrl, productBarcodeId: barcodeString, quantity: "1")
                            

                            
                            
                            DispatchQueue.main.async(execute: {
                                
                                if let orderId = self.orderInfo?.orderId {
                                    
                                    self.productInfo = productInfo
                                    self.orderId = orderId
//                                    self.captureSession.startRunning()
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScannedProductDetailsViewController") as! ScannedProductDetailsViewController
                                    vc.productInfo = self.productInfo
//                                    vc.view.setNeedsLayout()
//                                    vc.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                                    vc.orderId = self.orderId
                                    vc.view.frame = self.scannedProductDetailsContainerView.bounds
                                    vc.view.center = self.scannedProductDetailsContainerView.center
                                    self.view.addSubview(vc.view)
                                    self.addChildViewController(vc)
                                    vc.didMove(toParentViewController: self)
//                                    self.view.bringSubviewToFront(self.scannedProductDetailsContainerView)
                                    //                                        FacadeLayer.sharedInstance.updateProductsInOrder(productInfo, orderId: orderId, completionHandler: { (status) in
                                    //                                            if status {
                                    //                                                print("Product Saved to Orders")
                                    //                                            }
                                    //                                        })
                                    
                                }
                                
//                                let alertController = UIAlertController(title: "", message: "Do you want to save Product details?", preferredStyle: .Alert)
//                                
//                                let saveAction = UIAlertAction(title: "Save", style: .Default, handler:{ (action) in
//                                    if let orderId = self.orderInfo?.orderId {
//                                        
//                                        self.productInfo = productInfo
//                                        self.orderId = orderId
//                                    self.performSegueWithIdentifier("ScannedProductDetailsViewControllerSegue", sender: nil)
////                                        FacadeLayer.sharedInstance.updateProductsInOrder(productInfo, orderId: orderId, completionHandler: { (status) in
////                                            if status {
////                                                print("Product Saved to Orders")
////                                            }
////                                        })
//
//                                    }
//
//                                })
//                                
//                                let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler:{ (action) in
//                                     self.captureSession.startRunning()
//                                    
//                                })
//                                
//                                alertController.addAction(saveAction)
//                                alertController.addAction(cancelAction)
//                                
//                                self.presentViewController(alertController, animated: true, completion: nil)
                            })
                            
                        }
                    
                    
                }
                
            } catch {
                print("error: \(error)")
            }
            

            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    //let firstNameValue = convertedJsonIntoDict["productname"] as? String
                    // print(firstNameValue!)
                    
                }
            } catch _ as NSError {
                //print(error.localizedDescription)
            }
            
        }) 
        
        task.resume()

        
    }
    
    
    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!){
        //dataVal.appendData(data)
        //print(data)
    }
    
    
    //    func connectionDidFinishLoading(connection: NSURLConnection!)
    //    {
    //
    //        do {
    //            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
    //                print("ASynchronous\(jsonResult)")
    //            }
    //        } catch let error as NSError {
    //            print(error.localizedDescription)
    //        }
    //
    //
    //    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "ScannedProductDetailsViewControllerSegue") {
            let vc = segue.destination as! ScannedProductDetailsViewController
            vc.productInfo = self.productInfo
            vc.orderId = self.orderId
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
        }
    }

    
    
    
    fileprivate func showError(_ error:String)
    {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let dismiss:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler:{(alert:UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(dismiss)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

