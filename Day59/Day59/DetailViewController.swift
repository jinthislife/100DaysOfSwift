//
//  DetailViewController.swift
//  Day59
//
//  Created by LeeKyungjin on 04/05/2019.
//  Copyright © 2019 daisy. All rights reserved.
//

import UIKit

public extension UIView {
    
    func shakeView(view: UIView) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = 4
        animation.duration = 0.5/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-5), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(5), y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = 5) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation), y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
}

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    
    var country: Country!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = country.name.uppercased()
        imageView.image = UIImage(named: country.name)
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor

        let detail = """
        Location: \(country.location!)
        Capital: \(country.capital!)
        Population: \(country.population!)
        Ethnic Groups: \(country.ethnicGroups![0]), \(country.ethnicGroups![1]), \(country.ethnicGroups![2]), \(country.ethnicGroups![3]), \(country.ethnicGroups![4]))
        """
        detailLabel.text = detail
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.shake(count: 3, for: 0.3, withTranslation: 10)
        detailLabel.shake()
    }

}
