//
//  ViewController.swift
//  Anagram
//
//  Created by LeeKyungjin on 01/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var usedWords = [String]()
    var allWords: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if let resourcePath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let resourceContent = try? String(contentsOfFile: resourcePath) {
                allWords = resourceContent.components(separatedBy: "\n")
            }
        }
        
        title = allWords.randomElement()
        print("title = \(String(describing: title))")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAdd))
        
    }
    
    func submitAnswer(_ answer: String) {
        
    }

    @objc func tappedAdd() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak ac, weak self] action in
            if let answer = ac?.textFields?[0].text {
                self?.submitAnswer(answer)
            }
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Word")
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }


}

