//
//  ViewController.swift
//  Project5_Challenge
//
//  Created by LeeKyungjin on 28/03/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let websites = ["apple.com", "google.com", "hackingwithswift.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "webView") as? WebViewController {
            vc.website = websites[indexPath.row]
            vc.websites = websites
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

}

