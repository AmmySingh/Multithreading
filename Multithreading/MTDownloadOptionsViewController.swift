//
//  MTDownloadOptionsViewController.swift
//  Multithreading
//
//  Created by Itexico on 5/12/17.
//  Copyright © 2017 Amandeep Singh. All rights reserved.
//

import UIKit

let array_DownloadOptions = ["Main thread", "GCD - Concurrent Queue", "GCD - Serial Dispatch Queues", "OperationQueue - addOperation", "OperationQueue - blockOperation", "OperationQueue - blockOperation - CancelAndDependency"]

class MTDownloadOptionsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Multithreading"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as? MTDownloadViewController
        controller?.selected_Download_Option = DownloadOptions(rawValue: sender as! Int)!
    }
}

extension MTDownloadOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_DownloadOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = array_DownloadOptions[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SegueToDownloadScreen", sender: (indexPath.row))
    }
}
