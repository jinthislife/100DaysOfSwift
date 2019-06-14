//
//  DetailViewController.swift
//  Day74
//
//  Created by LeeKyungjin on 13/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func detailViewControllerDoneButtonTapped(_ viewController: DetailViewController)
}

class DetailViewController: UIViewController {
    let bgColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    let orange = UIColor(red: 232/255, green: 162/255, blue: 0, alpha: 1)
    var note: Note = Note()
    weak var delegate: DetailViewControllerDelegate?

    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        
        navigationController?.isToolbarHidden = false
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashPressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composePressed))
        
        delete.tintColor = orange
        compose.tintColor = orange
        toolbarItems = [delete, space, compose]
        
        view.backgroundColor = bgColor
        textView.backgroundColor = bgColor
        textView.text = note.detail
    }
    
    @objc func trashPressed() {
        
    }
    
    @objc func composePressed() {
        
    }
    
    @objc func donePressed() {
        note.detail = textView.text
        delegate?.detailViewControllerDoneButtonTapped(self)
        navigationController?.popViewController(animated: true)
    }
    
    
}
