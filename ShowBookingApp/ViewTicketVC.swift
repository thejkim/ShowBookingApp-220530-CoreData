//
//  ViewTicketVC.swift
//  ShowBookingApp
//
//  Created by Jo Eun Kim on 5/26/22.
//

import UIKit
import WebKit

class ViewTicketVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var targetUsername: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iOS/App/BookTicket/Document/Jo.pdf
        
        // URL(Uniform Resource Locator) vs Path
        // URI(Indicator) > URL, URN(Name)
                
        // default setting folder provided for file saving, reading, writing, ...
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first // 1. go to document directory
        let filePath = documentURL?.appendingPathComponent("\(targetUsername).pdf").path
        
        if let filePath = filePath, FileManager.default.fileExists(atPath: filePath) { // 2. check if file exists
            JKLog.log(message: "exists")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath)) // Data() : buffer
                
                // application/... : serialized
                // translate data to given mimeType
                // if mimeType is text, need to let it know characterEncodingName (like UTF-8, UTF-16, ...)
                webView.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: URL(fileURLWithPath: filePath).deletingPathExtension()) // 3. load
            } catch {
                
            }
        } else {
            JKLog.log(message: "not exists")
        }
    }
    
}
