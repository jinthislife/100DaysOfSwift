//
//  ViewController.swift
//  Day90
//
//  Created by LeeKyungjin on 01/07/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meme Generator"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
        
        navigationController?.isToolbarHidden = false
        let addText = UIBarButtonItem(title: "Add Text", style: .plain, target: self, action: #selector(addTextTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionTapped))
        toolbarItems = [addText, space, share]
    }
    
    @objc func actionTapped() {
        guard let image = imgView.image?.jpegData(compressionQuality: 0.8) else { return }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = toolbarItems?.last
        present(vc, animated: true)
    }
    
    @objc func addTextTapped() {
        let ac = UIAlertController(title: "Write and append text for your meme", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "At the top", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?.first?.text else { return }
            self?.renderImageAndText(text, alignToTop: true)
        })
        ac.addAction(UIAlertAction(title: "At the bottom", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?.first?.text else { return }
            self?.renderImageAndText(text, alignToTop: false)
            
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    
    func renderImageAndText(_ text: String, alignToTop: Bool) {
        guard let sourceImage = imgView.image else {
            return
        }

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: sourceImage.size.width, height: sourceImage.size.height))
        
        let img = renderer.image { [unowned sourceImage] ctx in
            // draw base image
            sourceImage.draw(at: CGPoint(x: 0, y: 0))
            
            // prepare for NSAttributesString
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 64, weight: .bold),
                                                         .strokeColor: UIColor.yellow,
                                                         .strokeWidth: -2,
                                                         .foregroundColor: UIColor.blue,
                                                         .paragraphStyle: paragraphStyle]
            
            let attrString = NSAttributedString(string: text, attributes: attrs)
            
            if alignToTop == true {
                attrString.draw(with: CGRect(x: 26, y: 26, width: Int(sourceImage.size.height - 52), height: 150), options: .usesLineFragmentOrigin, context: nil)
            } else {
                attrString.draw(with: CGRect(x: 26, y: Int(sourceImage.size.height) - 80, width: Int(sourceImage.size.height - 52), height: 150), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        imgView.image = img
    }
    
    @objc func importImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imgView.image = image
        dismiss(animated: true)
    }
}

