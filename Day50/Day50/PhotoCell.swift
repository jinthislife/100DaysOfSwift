//
//  PhotoCell.swift
//  Day50
//
//  Created by LeeKyungjin on 20/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate: NSObjectProtocol {
    func photoCell(_ photoCell: PhotoCell, didTapCaptionOf photo: Photo)
}

class PhotoCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var captionButton: UIButton!
    weak var collectionVC: ViewController?
    
    weak var delegate: PhotoCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
    }

    var photo: Photo? {
        didSet {
            if let photo = photo {
                let imageURL = getDocumentsDirectory().appendingPathComponent(photo.image)
                imageView.image = UIImage(contentsOfFile: imageURL.path)
                captionButton.setTitle(photo.name, for: .normal)
            }
        }
    }

    @IBAction func captionPressed(_ sender: UIButton) {
        collectionVC?.editPhotoCaption(self)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
