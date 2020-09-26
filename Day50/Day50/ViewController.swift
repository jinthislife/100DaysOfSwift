//
//  ViewController.swift
//  Day50
//
//  Created by LeeKyungjin on 20/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UICollectionViewController {
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as? PhotoCollectionViewLayout
        layout?.delegate = self

        
        if let savedPhotos = UserDefaults.standard.object(forKey: "photos") as? Data {
            if let decodedPhotos = try? JSONDecoder().decode([Photo].self, from: savedPhotos) {
                photos = decodedPhotos
            }
//            photos = try? JSONDecoder().decode([Photo].self, from: savedPhotos) ?? [Photo]()
        }
        title = "Photo Gallery"
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        if let photoCell = cell as? PhotoCell {
            photoCell.collectionVC = self
            photoCell.photo = photos[indexPath.item]
            photoCell.delegate = self
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            vc.photo = photos[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func addTapped() {
        let ac = UIAlertController(title: "Get Photo", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Photos", style: .default, handler: openPhotoGallery))
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
        ac.addAction(UIAlertAction(title: "Cancel", style: . cancel))
        present(ac, animated: true)
    }

    func openCamera(action: UIAlertAction) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func openPhotoGallery(action: UIAlertAction) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true)
        
        let photo = Photo(name: "Unknown", image: imageName)
        photos.append(photo)
        collectionView.reloadData()

        if let encodedPhotos = try? JSONEncoder().encode(photos) {
            UserDefaults.standard.set(encodedPhotos, forKey: "photos")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func editPhotoCaption(_ photoCell: PhotoCell) {
        let selectedPhoto = photoCell.photo
        let ac = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            if let newCaption = ac?.textFields?[0].text {
                selectedPhoto?.name = newCaption
            }
            if let encodedPhotos = try? JSONEncoder().encode(self?.photos) {
                UserDefaults.standard.set(encodedPhotos, forKey: "photos")
            }
//            self?.collectionView.reloadData()
            photoCell.photo = selectedPhoto
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

extension ViewController: PhotoCellDelegate {
    func photoCell(_ photoCell: PhotoCell, didTapCaptionOf photo: Photo) {
//        let ac = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
//        ac.addTextField()
//        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
//            if let editedText = ac?.textFields?[0].text {
//                photo.name = editedText
//            }
//        }))
        
    }
}

extension ViewController: PhotoCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let imagePath = getDocumentsDirectory().appendingPathComponent(photos[indexPath.item].image)
        if let image = UIImage(contentsOfFile: imagePath.path) {
//            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
//            let rect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)
//
//            height = rect.size.height
            let scaledImage = imageWithImage(sourceImage: image, scaledToWidth: width)
            return scaledImage.size.height
        }
        return 0
    }
    
    func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let text = photos[indexPath.item].name
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold)], context: nil)
        return ceil(rect.size.height)
    }
}
