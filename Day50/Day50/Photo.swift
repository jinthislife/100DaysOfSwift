//
//  Photo.swift
//  Day50
//
//  Created by LeeKyungjin on 20/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import Foundation
import UIKit

class Photo: Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
