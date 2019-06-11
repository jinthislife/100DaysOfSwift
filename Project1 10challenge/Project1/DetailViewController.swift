//
//  DetailViewController.swift
//  Project1
//
//  Created by LeeKyungjin on 19/03/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var imageNumber: Int?
    var totalNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let imageNumber = imageNumber, let totalNumber = totalNumber {
            title = "Picture \(imageNumber) of \(totalNumber)"
        }
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
