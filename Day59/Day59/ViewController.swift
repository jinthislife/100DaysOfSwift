//
//  ViewController.swift
//  Day59
//
//  Created by LeeKyungjin on 04/05/2019.
//  Copyright © 2019 daisy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Countries"
        if let path = Bundle.main.path(forResource: "document", ofType: "json") {
            let fileurl = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: fileurl) {
//                if let results = try? JSONDecoder().decode(Countries.self, from: data) {
//                    countries = results.result
//
//                    print("parse result: \(countries)")
//                }
                do {
                    let results = try JSONDecoder().decode(Countries.self, from: data)
                    countries = results.result
                    print("parse result: \(countries)")
                } catch let error as NSError {
                    print("\(error)")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.imageView?.image = UIImage(named: countries[indexPath.row].name)
        cell.textLabel?.text = countries[indexPath.row].name.uppercased()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailView") as? DetailViewController {
            vc.country = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
