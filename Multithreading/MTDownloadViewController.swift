//
//  MTDownloadViewController.swift
//  Multithreading
//
//  Created by Itexico on 5/12/17.
//  Copyright © 2017 Amandeep Singh. All rights reserved.
//

import UIKit

enum DownloadOptions: Int {
    case mainThread = 0
    case concurrentQueue
    case serialDispatchQueues
    case operationQueueUsingAddOperation
    case operationQueueUsingBlockOperation
    case operationQueueUsingCancelAndDependency
}

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://webneel.com/wallpaper/sites/default/files/images/02-2013/valentine-day-wallpaper-1.jpg", "http://images6.fanpop.com/image/photos/38500000/beautiful-wallpaper-7-beautiful-pictures-38538899-500-281.jpg"]

class Downloader {
    
    class func downloadImageWithURL(_ url:String) -> UIImage! {
        
        let data = try? Data(contentsOf: URL(string: url)!)
        return UIImage(data: data!)
    }
}

class MTDownloadViewController: UIViewController {
    
    let queue_Gobal = OperationQueue()
    var selected_Download_Option = DownloadOptions.mainThread
    
    @IBOutlet weak var button_Cancel: UIBarButtonItem!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button_Cancel.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickOnCancel(_ sender: Any) {
        
        queue_Gobal.cancelAllOperations()
    }
    
    @IBAction func didClickOnStart(_ sender: AnyObject) {
        
        switch selected_Download_Option {
        case .mainThread:
            download_MainThread()
        case .concurrentQueue:
            download_ConcurrentQueue()
        case .serialDispatchQueues:
            download_SerialQueue()
        case .operationQueueUsingAddOperation:
            download_OperationQueueUsingAddOperation()
        case .operationQueueUsingBlockOperation:
            download_OperationQueueUsingBlockOperation()
        default:
            button_Cancel.isEnabled = true
            download_OperationQueueUsingCancelAndDependency()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        self.sliderValueLabel.text = "\(sender.value * 100.0)"
    }
    
    func download_MainThread() {
        let img1 = Downloader.downloadImageWithURL(imageURLs[0])
        self.imageView1.image = img1
        
        let img2 = Downloader.downloadImageWithURL(imageURLs[1])
        self.imageView2.image = img2
        
        let img3 = Downloader.downloadImageWithURL(imageURLs[2])
        self.imageView3.image = img3
        
        let img4 = Downloader.downloadImageWithURL(imageURLs[3])
        self.imageView4.image = img4
    }
    
    // Fast then Serial Queue b'coz all the tasks execute at same time.
    func download_ConcurrentQueue() {
        
        let queue = DispatchQueue.global(qos: .default)
        
        queue.async() { () -> Void in
            
            let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            
            DispatchQueue.main.async(execute: {
                self.imageView1.image = img1
            })
        }
        
        queue.async() { () -> Void in
            
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            
            DispatchQueue.main.async(execute: {
                self.imageView2.image = img2
            })
        }
        
        queue.async() { () -> Void in
            
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            
            DispatchQueue.main.async(execute: {
                self.imageView3.image = img3
            })
            
        }
        queue.async() { () -> Void in
            
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            
            DispatchQueue.main.async(execute: {
                self.imageView4.image = img4
            })
        }
    }
    
    // Takes more time the concurrent queue execution b'coz it execute operations in series and wait for task to finish.
    func download_SerialQueue () {
        
        let serialQueue = DispatchQueue(label: "com.appcoda.imagesQueue")
        
        serialQueue.async() { () -> Void in
            
            let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            
            DispatchQueue.main.async(execute: {
                self.imageView1.image = img1
            })
        }
        
        serialQueue.async() { () -> Void in
            
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            
            DispatchQueue.main.async(execute: {
                self.imageView2.image = img2
            })
        }
        
        serialQueue.async() { () -> Void in
            
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            
            DispatchQueue.main.async(execute: {
                self.imageView3.image = img3
            })
            
        }
        serialQueue.async() { () -> Void in
            
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            
            DispatchQueue.main.async(execute: {
                self.imageView4.image = img4
            })
        }
    }
    
    // Completion block called when finish property become true.
    func download_OperationQueueUsingAddOperation () {
        
        let queue = OperationQueue()
        
        queue.addOperation { () -> Void in
            let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            
            OperationQueue.main.addOperation({
                self.imageView1.image = img1
            })
        }
        
        queue.addOperation { () -> Void in
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            
            OperationQueue.main.addOperation({
                self.imageView2.image = img2
            })
        }
        
        queue.addOperation { () -> Void in
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            
            OperationQueue.main.addOperation({
                self.imageView3.image = img3
            })
        }
        
        queue.addOperation { () -> Void in
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            
            OperationQueue.main.addOperation({
                self.imageView4.image = img4
            })
        }
    }
    
    func download_OperationQueueUsingBlockOperation () {
        
        let queue = OperationQueue()
        
        let operation1 = BlockOperation(block: {
            let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            OperationQueue.main.addOperation({
                self.imageView1.image = img1
            })
        })
        
        operation1.completionBlock = {
            print("Operation 1 completed")
        }
        queue.addOperation(operation1)
        
        let operation2 = BlockOperation(block: {
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            OperationQueue.main.addOperation({
                self.imageView2.image = img2
            })
        })
        
        operation2.completionBlock = {
            print("Operation 2 completed")
        }
        queue.addOperation(operation2)
        
        
        let operation3 = BlockOperation(block: {
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            OperationQueue.main.addOperation({
                self.imageView3.image = img3
            })
        })
        
        operation3.completionBlock = {
            print("Operation 3 completed")
        }
        queue.addOperation(operation3)
        
        let operation4 = BlockOperation(block: {
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            OperationQueue.main.addOperation({
                self.imageView4.image = img4
            })
        })
        
        operation4.completionBlock = {
            print("Operation 4 completed")
        }
        queue.addOperation(operation4)
    }
    
    func download_OperationQueueUsingCancelAndDependency () {
        
        let operation1 = BlockOperation(block: {
            let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            OperationQueue.main.addOperation({
                self.imageView1.image = img1
            })
        })
        
        operation1.completionBlock = {
            print("Operation 1 completed, cancelled:\(operation1.isCancelled)")
        }
        queue_Gobal.addOperation(operation1)
        
        let operation2 = BlockOperation(block: {
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            OperationQueue.main.addOperation({
                self.imageView2.image = img2
            })
        })
        
        operation2.completionBlock = {
            print("Operation 2 completed")
        }
        queue_Gobal.addOperation(operation2)
        
        let operation3 = BlockOperation(block: {
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            OperationQueue.main.addOperation({
                self.imageView3.image = img3
            })
        })
        
        operation3.completionBlock = {
            print("Operation 3 completed")
        }
        queue_Gobal.addOperation(operation3)
        
        let operation4 = BlockOperation(block: {
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            OperationQueue.main.addOperation({
                self.imageView4.image = img4
            })
        })
        
        operation4.completionBlock = {
            print("Operation 4 completed")
        }
        queue_Gobal.addOperation(operation4)
        
        // Add Dependency.
        operation2.addDependency(operation1)
        operation3.addDependency(operation2)
    }
}

