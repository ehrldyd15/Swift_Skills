//
//  ViewController.swift
//  FileDownloader_Preview
//
//  Created by Do Kiyong on 2022/12/07.
//

import UIKit

class ViewController: UIViewController {
    
    // Sample PDF URL
    let pdfURL = "http://www.africau.edu/images/default/sample.pdf"
    
    // UIDocumentInteractionController
    var interaction:UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func startFileDownload() {
        fileDownload { (success, path) in
            DispatchQueue.main.async(execute: {
                self.openFileWithPath(pdfPath: path)
            })
        }
    }
    
    func fileDownload(completion: @escaping (_ success:Bool, _ pdfURL:URL) -> ()) {
        
        // Check pdfURL
        guard let url = URL(string: pdfURL) else {
            print("Error: cannot create URL")
            return
        }
        
        // set up URLRequest
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            // getting Data Error
            guard error == nil else {
                debugPrint("Error!!")
                return
            }
            
            // Respose Data Empty
            guard let responseData = data else {
                print("Error: data empty!!")
                return
            }
            
            // FileManager 인스턴스 생성
            let fileManager = FileManager()
            
            // document 디렉토리의 경로 저장
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // 해당 디렉토리 이름 지정
            let dataPath = documentsDirectory.appendingPathComponent("FileManager Directory")
            
            do {
                // 디렉토리 생성
                try fileManager.createDirectory(atPath: dataPath.path, withIntermediateDirectories: false, attributes: nil)
                
            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }
            
            do {
                
                // 파일 이름을 기존의 경로에 추가
                let writePath = dataPath.appendingPathComponent("sample.pdf")
                
                // 쓰기 작업
                try responseData.write(to: writePath)
                
                completion(true, writePath)
                
            } catch let error as NSError {
                print("Error Writing File : \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
        
    }
    
    func openFileWithPath(pdfPath : URL) {
        interaction = UIDocumentInteractionController(url: pdfPath)
        interaction?.delegate = self
        interaction?.presentPreview(animated: true) // IF SHOW DIRECT
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
