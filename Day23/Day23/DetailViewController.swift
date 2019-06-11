//
//  DetailViewController.swift
//  Day23
//
//  Created by LeeKyungjin on 25/03/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!

    var imageName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = imageName?.components(separatedBy: ".png").first?.uppercased()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(tappedShared))

        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @objc func tappedShared() {
        guard let imageName = imageName else {
            print("image not found")
            return
        }
        
        if let image = UIImage(named: imageName)?.jpegData(compressionQuality: 0.8) {
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    }

}
