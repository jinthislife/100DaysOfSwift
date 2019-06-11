//
//  Picture.swift
//  Project1
//
//  Created by LeeKyungjin on 16/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import Foundation

class Picture: NSObject, NSCoding {
    var name: String
    var viewCount: Int
    
    init(name: String, viewCount: Int) {
        self.name = name
        self.viewCount = viewCount
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(viewCount, forKey: "viewCount")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        viewCount = aDecoder.decodeInteger(forKey: "viewCount")
    }
}

