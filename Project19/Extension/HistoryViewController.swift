//
//  HistoryViewController.swift
//  Extension
//
//  Created by LeeKyungjin on 10/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

    var histories = [History]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "history")
        cell.textLabel?.text = histories[indexPath.row].title
        cell.detailTextLabel?.text = histories[indexPath.row].url
        return cell
    }

}
