//
//  ViewController.swift
//  Project10
//
//  Created by LeeKyungjin on 08/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showActionSheet))
        if let data = UserDefaults.standard.object(forKey: "people") as? Data {
            do {
                people = try JSONDecoder().decode([Person].self, from: data)
            } catch {
                print("Failed to load people")
            }
        }
    }

    @objc func showActionSheet() {
        let ac = UIAlertController(title: "Get photo", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: takeNewPhoto))
        ac.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: addNewPerson))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func addNewPerson(action: UIAlertAction) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func takeNewPhoto(action: UIAlertAction) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        save()
        
        dismiss(animated: true)
    }
    
    func getDocumentDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls [0]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }

        let person = people[indexPath.item]
        let imagePath = getDocumentDirectory().appendingPathComponent(person.image)
        cell.name.text = person.name
        cell.imageView.image = UIImage(contentsOfFile: imagePath.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            if let person = self?.people[indexPath.row] {
                self?.showEditNameAlert(person: person)
            }
        })
        ac.addAction(UIAlertAction(title: "Delete", style: .default){ [weak self] _ in
            if let person = self?.people[indexPath.row] {
                if let photoPath = self?.getDocumentDirectory().appendingPathComponent(person.image) {
                    try? FileManager.default.removeItem(atPath: photoPath.path)
                    self?.people.remove(at: indexPath.item)
                    self?.collectionView.reloadData()
                    self?.save()
                }
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func showEditNameAlert(person: Person) {
        let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default){ [weak self, weak ac, weak person] _ in
            if let newName = ac?.textFields?[0].text {
                person?.name = newName
                self?.collectionView.reloadData()
                self?.save()
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    func save() {
        guard let data = try? JSONEncoder().encode(people) else {
            print("Save failed")
            return
        }
        UserDefaults.standard.set(data, forKey: "people")
    }
    

}

