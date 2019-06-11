//
//  ViewController.swift
//  Project12
//
//  Created by LeeKyungjin on 13/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        
        defaults.set(true, forKey: "IsTrue")
        defaults.set("Junior Developer", forKey: "JobTitle")
        defaults.set(161.3, forKey: "HeightForJin")

        let blackpink = ["Jisu", "Rose", "Jenny", "Lisa"]
        defaults.set(blackpink, forKey: "BPMember")
        
        let profile = ["Name": "Jenny", "BType": "A"]
        defaults.set(profile, forKey: "Jenny")
        
        print("Bool for not-existing key = \(defaults.bool(forKey: "IsFalse"))")
        print("Value for JobTitle key = \(defaults.object(forKey: "JobTitle") as? String ?? "")")
        print("Blackpink members are \(defaults.object(forKey: "BPMember") as? [String] ?? [String]())")
        print("Jenny profile: \(defaults.object(forKey: "Jenny") as? [String: String] ?? [String: String]())")
    }


}

