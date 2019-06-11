//
//  History.swift
//  Extension
//
//  Created by LeeKyungjin on 10/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import Foundation

class History: NSObject, Codable {
    var title: String?
    var url: String?
    
    init(title: String?, url: String?) {
        self.title = title
        self.url = url
    }
}
