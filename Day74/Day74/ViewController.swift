//
//  ViewController.swift
//  Day74
//
//  Created by LeeKyungjin on 13/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, DetailViewControllerDelegate {

    let orange = UIColor(red: 232/255, green: 162/255, blue: 0, alpha: 1)
    let bgColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    let bgColorTransparent = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 0.5)
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //set navigationBar transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed))
        
        navigationController?.isToolbarHidden = false
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let create = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        create.tintColor = orange
        toolbarItems = [space, create]
        
        //set toolbar transpanrent
        navigationController?.toolbar.barTintColor = bgColorTransparent
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

//        tableView.register(NoteCell.self, forCellReuseIdentifier: "noteCell") //what a problematic line
        self.loadNotes()
        tableView.backgroundColor = bgColor
        tableView.reloadData()
//        DispatchQueue.global().async {
//            self.loadNotes()
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NoteCell {

        let detail = notes[indexPath.row].detail
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/M/yy"
        let dateStr = formatter.string(from: notes[indexPath.row].date)

        var sentences = detail.components(separatedBy: "\n")
        cell.titleLabel?.text = sentences.removeFirst()
        cell.dateLabel?.text = dateStr
        cell.detailLabel?.text = sentences.joined(separator: "\n")
        return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadDetailView(notes[indexPath.row])
    }
    
    func loadDetailView(_ note: Note) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.note = note
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func editPressed() {
        
    }

    @objc func createNote() {
        let note = Note()
        notes.insert(note, at: 0)
        loadDetailView(note)
    }

    func detailViewControllerDoneButtonTapped(_ viewController: DetailViewController) {
        let note = viewController.note
        if note.detail.isEmpty {
            if let index = notes.firstIndex(where: { $0.uuid == note.uuid }) {
                notes.remove(at: index)
            }
            return
        }
        saveNotes()
    }

    func loadNotes() {
        guard let data = UserDefaults.standard.object(forKey: "notes") as? Data else {
            print("Can't find notes")
            return
        }

        do {
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("fail to decode")
        }
    }
    
    func saveNotes() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: "notes")
        } else {
            print("fail to encode")
        }
    }
}

