//
//  ViewController.swift
//  Project7
//
//  Created by LeeKyungjin on 02/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filtedPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))

        performSelector(inBackground: #selector(fetchPetitions), with: nil)
    }
    
    @objc func fetchPetitions() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
            return
        }

        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func showFiltedPetition(with word: String) {
        DispatchQueue.global().async { [weak self] in
            self?.filtedPetitions.removeAll()
            if let petitions = self?.petitions {
                self?.filtedPetitions = petitions.filter {
                    $0.title.lowercased().contains(word) || $0.body.lowercased().contains(word)
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    @objc func creditsTapped(action: UIAlertAction) {
        let ac = UIAlertController(title: "Credits", message: "The petitions comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func searchTapped(action: UIAlertAction) {
        let ac = UIAlertController(title: "Enter word", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] (action) in
            guard let word = ac?.textFields?[0].text else { return }
            self?.showFiltedPetition(with: word)
        }
        ac.addAction(searchAction)
        present(ac, animated: true)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func parseError() {
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        guard let data = try? decoder.decode(Petitions.self, from: json) else {
            performSelector(onMainThread: #selector(parseError), with: nil, waitUntilDone: false)
            return
        }
        petitions = data.results

        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtedPetitions.isEmpty {
            return petitions.count
        }
        return filtedPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if filtedPetitions.isEmpty {
            cell.textLabel?.text = petitions[indexPath.row].title
            cell.detailTextLabel?.text = petitions[indexPath.row].body
        } else {
            cell.textLabel?.text = filtedPetitions[indexPath.row].title
            cell.detailTextLabel?.text = filtedPetitions[indexPath.row].body
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if filtedPetitions.isEmpty {
            vc.detailItem = petitions[indexPath.row]
        } else {
            vc.detailItem = filtedPetitions[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}


