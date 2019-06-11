//
//  Country.swift
//  Day59
//
//  Created by LeeKyungjin on 04/05/2019.
//  Copyright © 2019 daisy. All rights reserved.
//

import Foundation

struct Country: Codable {
    var name: String
    var location: String?
    var capital: String?
    var population: String?
    var callingCode: String?
    var ethnicGroups: [String]?
}
