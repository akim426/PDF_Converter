//
//  ViewController.swift
//  pdf_converter
//
//  Created by Andrew Kim on 10/15/23.
//

import UIKit

class ViewController: UIViewController {
    
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtToString()
        convertToPdf()
    }
    
    func txtToString() {
 
        let manager = FileManager.default
        guard let url = manager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return
        }
        print(url.path)

        let newFolderUrl = url.appendingPathComponent("txt_to_pdf")
        let fileUrl = newFolderUrl.appendingPathComponent("txt_file.txt")
        let data = "Writing text to a file! Let's go".data(using: .utf8)
        manager.createFile(
            atPath: fileUrl.path,
            contents: data,
            attributes: [FileAttributeKey.creationDate : Date()]
        )
        
        
        do {
            text = try String(contentsOf: fileUrl, encoding: .utf8)
        }
        catch {
            print(error)
        }
        
    }
    
    func convertToPdf() {
        let fmt = UIMarkupTextPrintFormatter(markupText: text)
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        
        //Define Page Dimensions
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) //A4
        render.setValue(page, forKey: "paperRect")
        render.setValue(page, forKey: "printableRect")
        
        //Create PDF Data
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        
        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage()
            render.drawPage(at: i, 	in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        
        //Define the ouput
        guard let outputURL = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false).appendingPathComponent("output.pdf")
            else { return }
        
        pdfData.write(to: outputURL, atomically: true)
        
        
    }
    
}

