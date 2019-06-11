//
//  Script.swift
//  Extension
//
//  Created by LeeKyungjin on 09/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import Foundation

class Script: NSObject, Codable {
    var name: String
    var jscript: String
    
    init(name: String, jscript: String) {
        self.name = name
        self.jscript = jscript
    }
}
