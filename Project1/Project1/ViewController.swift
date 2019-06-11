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

        if let savedData = UserDefaults.standard.value(forKey: "pictures") as? Data {
            if let savedPictures = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Picture] {
                pictures = savedPictures
            }
            return
        }
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
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
        if let pictureData = try? NSKeyedArchiver.archivedData(withRootObject: pictures, requiringSecureCoding: false) {
            UserDefaults.standard.set(pictureData, forKey: "pictures")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "etail") as? DetailViewController {
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

