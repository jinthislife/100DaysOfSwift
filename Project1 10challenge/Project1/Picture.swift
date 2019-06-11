//
//  Picture.swift
//  Project1
//
//  Created by LeeKyungjin on 16/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import Foundation

struct Picture: Codable {
    var name: String
    var viewCount: Int
    
    init(name: String, viewCount: Int) {
        self.name = name
        self.viewCount = viewCount
    }
}

