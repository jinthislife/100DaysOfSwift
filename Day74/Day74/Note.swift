//
//  Note.swift
//  Day74
//
//  Created by LeeKyungjin on 13/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import Foundation

class Note: Codable {
    var detail = ""
    var date = Date()
    var uuid = UUID().uuidString
}
