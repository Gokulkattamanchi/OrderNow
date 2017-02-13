//
//  PDFViewController.swift
//  inventoryPlus
//
//  Created by Gokul Kattamanchi on 11/24/16.
//  Copyright © 2016 Monmouth University. All rights reserved.
//
import UIKit

class PDFViewController: UIViewController {
  
  @IBOutlet var webView: UIWebView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the pdf
        createPDF()
        
        // Load the pdf file in a UIWebView
        if let url = documentPath() {
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    // Document Directory URL
    private func documentPath() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let documentsUrl = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        return documentsUrl.URLByAppendingPathComponent("products.pdf")
    }
    
  private func createPDF() {
    // Create PDF
    // set the default page size to 8.5 by 11 inches
    // (612 by 792 points).
    
    guard let pdfPath = documentPath()?.path else { return }
    
    UIGraphicsBeginPDFContextToFile(pdfPath, .zero, nil)
    
    UIGraphicsBeginPDFPage()
    renderBackground()
    
//    renderCategories()
    
    UIGraphicsEndPDFContext()
    
  }

//
  func renderBackground() {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    let rect = CGContextGetClipBoundingBox(context)
    //.setFill()
    UIRectFill(rect)
    
  }

//  func renderCategories() {
//    guard let context = UIGraphicsGetCurrentContext() else { return }
//    
//    guard let budgetController = storyboard?.instantiateViewControllerWithIdentifier("ProductDetailsViewController") as? ProductDetailsViewController else {  return }
//    let cnt = 2
//    //let width = budgetController.productDetailsTableView.contentSize.cnt
//    //let height = budgetController.productDetailsTableView.rowHeight * CGFloat(cnt)
//    
//    let frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
//    budgetController.productDetailsTableView.frame = frame
//    
//    CGContextSaveGState(context)
//    
//    let rect = CGContextGetClipBoundingBox(context)
//    
//    CGContextTranslateCTM(context,
//                (rect.width - width)  / 2,
//                (rect.height - height) / 2)
//    
//    
//    budgetController.productDetailsTableView.layer.renderInContext(context)
//    
//    CGContextRestoreGState(context)
//    
//    let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(36),
//      NSForegroundColorAttributeName: UIColor.whiteColor()]
//    
//    let title = "PennyWise Budget"
//    title.drawAtPoint(CGPoint(x: 32, y: 40), withAttributes: attributes)
//    
  }





