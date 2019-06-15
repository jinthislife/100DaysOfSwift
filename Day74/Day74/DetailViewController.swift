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

class DetailViewController: UIViewController, UITextViewDelegate {

    var note: Note = Note()
    weak var delegate: DetailViewControllerDelegate?

    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePressed))
        
        navigationController?.isToolbarHidden = false
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashPressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composePressed))
        
        delete.tintColor = UIColor(named: "MyOrange")
        compose.tintColor = UIColor(named: "MyOrange")
        toolbarItems = [delete, space, compose]
        
        view.backgroundColor = UIColor(named: "BGColor")
        textView.delegate = self
        textView.backgroundColor = UIColor(named: "BGColor")
        textView.text = note.detail
        textView.tintColor = UIColor(named: "MyOrange")
        textView.contentInset = UIEdgeInsets(top: 0, left: 17, bottom: view.safeAreaInsets.bottom, right: 15)
        
        if note.detail.isEmpty {
            textView.becomeFirstResponder()
        }
    }
    
    @objc func trashPressed() {
        
    }
    
    @objc func composePressed() {
        
    }
    
    @objc func sharePressed() {
        
    }

    @objc func donePressed() {
        note.detail = textView.text
        delegate?.detailViewControllerDoneButtonTapped(self)
        navigationController?.popViewController(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePressed))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        navigationItem.rightBarButtonItems = [share, done]
    }
    
}
