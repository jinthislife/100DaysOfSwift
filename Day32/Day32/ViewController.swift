//
//  ViewController.swift
//  Day32
//
//  Created by LeeKyungjin on 01/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shopping List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(tappedClear))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAdd))
    }
    
    @objc func tappedAdd() {
        let ac = UIAlertController(title: "Enter product", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let action = UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] action in
            guard let item = ac?.textFields?[0].text else { return }
            self?.addItem(item)
        }
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func addItem(_ item: String) {
        shoppingList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    @objc func tappedClear() {
        shoppingList.removeAll(keepingCapacity: true) // what keepingCapacity?
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
}

