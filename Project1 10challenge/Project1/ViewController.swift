//
//  ViewController.swift
//  Project1
//
//  Created by LeeKyungjin on 18/03/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "StormViewer"
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        if let data = UserDefaults.standard.value(forKey: "pictures") as? Data {
            let decoder = JSONDecoder()
            do {
                pictures = try decoder.decode([Picture].self, from: data)
            } catch {
                print("Failed to decode")
            }
            return
        }

        for item in items {
            if item.hasPrefix("nssl") {
                let picture = Picture(name: item, viewCount: 0)
                pictures.append(picture)
            }
        }
        pictures.sort{ $0.name < $1.name }

        print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture.name
        cell.detailTextLabel?.text = "\(picture.viewCount)"
        return cell
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(pictures) {
            UserDefaults.standard.set(data, forKey: "pictures")
        } else {
            print("Failed to encode")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row].name
            vc.imageNumber = indexPath.row + 1
            vc.totalNumber = pictures.count
            pictures[indexPath.row].viewCount += 1
            save()
            navigationController?.pushViewController(vc, animated: true)
            tableView.reloadData()
        }
    }

}

