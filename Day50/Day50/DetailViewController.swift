//
//  DetailViewController.swift
//  Day50
//
//  Created by LeeKyungjin on 21/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        if let photo = photo {
            title = photo.name
            let imageURL = getDocumentsDirectory().appendingPathComponent(photo.image)
            imageView.image = UIImage(contentsOfFile: imageURL.path)
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
