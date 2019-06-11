//
//  ViewController.swift
//  Day23
//
//  Created by LeeKyungjin on 25/03/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var flags = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "World Flags"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath
        let items = try! fm.contentsOfDirectory(atPath: path!)
        
        for item in items {
            if item.hasSuffix("png"), let flag = item.components(separatedBy: ".png").first {
                flags.append(flag)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.imageView?.image = UIImage(named: flags[indexPath.row])
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.textLabel?.text = flags[indexPath.row].uppercased()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController {
            vc.imageName = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

