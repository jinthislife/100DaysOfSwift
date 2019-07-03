//
//  Person.swift
//  Project10
//
//  Created by LeeKyungjin on 09/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import Foundation

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        print("Creating Person")
        self.name = name
        self.image = image
    }

    required init?(coder aDecoder: NSCoder) {
        print("Decoding Person...")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
