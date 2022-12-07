//
//  ViewController.swift
//  FileDownloader_Preview
//
//  Created by Do Kiyong on 2022/12/07.
//

import UIKit

class ViewController: UIViewController {
    
    // UIDocumentInteractionController
    var interaction:UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func startFileDownload() {
        guard let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf") else { return }
        
        Utils.downloadFileAsync(url: url, completion: { (path, error) in
            DispatchQueue.main.async(execute: {
                guard let path = URL(string: path ?? "") else { return }
                self.openFileWithPath(pdfPath: path)
            })
        })
    }
    
    func openFileWithPath(pdfPath : URL) {
        interaction = UIDocumentInteractionController(url: pdfPath)
        interaction?.delegate = self
        interaction?.presentPreview(animated: true)
    }
    
}

extension ViewController : UIDocumentInteractionControllerDelegate {
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
        return self
    }
    
    public func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        interaction = nil
    }
}
