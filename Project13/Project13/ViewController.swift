//
//  ViewController.swift
//  Project13
//
//  Created by LeeKyungjin on 23/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var scale: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var filterButton: UIButton!
    
    var currentImage: UIImage!
    var tempImage: CIImage!
    var context: CIContext!
    var currentFilter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
        filterButton.isHidden = true
    }
    
    @objc func importImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        //applyProcessing()
    }

    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter)) // radius
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter)) //radius
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter)) //scale
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter)) //intensity
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let filterName = action.title else { return }

        filterButton.setTitle(filterName, for: .normal)
        currentFilter = CIFilter(name: filterName)
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
    
    func setFilter(name: String) {

        guard let image = imageView.image else { return }
        tempImage = CIImage(image: image)
        guard tempImage != nil else { return }
        if currentFilter.name != name {
            currentFilter = CIFilter(name: name)
            currentFilter.setValue(tempImage, forKey: kCIInputImageKey)
        }

    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "No image is loaded", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
            
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @IBAction func intensityChanged(_ sender: Any) { //sepia
        applySepia()
        applyProcessing()
    }
    
    @IBAction func radiusChanged(_ sender: Any) { //twirl
        applyTwirl()
        applyProcessing()
    }

    @IBAction func scaleChanged(_ sender: Any) { //pixel
        applyPixellerate()
        applyProcessing()
    }

    func applySepia() {
        setFilter(name: "CISepiaTone")
    }
    
    func applyTwirl() {
        setFilter(name: "CITwirlDistortion")
    }
    
    func applyPixellerate() {
        setFilter(name: "CIPixellate")
    }
    func applyProcessing() {

        let inputKeys = currentFilter.inputKeys
        print(inputKeys)
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }

//        tempImage = currentFilter.outputImage
//
//        guard tempImage != nil else { return }
//        if let cgImage = context.createCGImage(tempImage, from: tempImage.extent) {
//            let processedImage = UIImage(cgImage: cgImage)
//            imageView.image = processedImage
//        }
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage , from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle:    .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

