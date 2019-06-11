//
//  Person.swift
//  Project10
//
//  Created by LeeKyungjin on 09/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import Foundation

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
