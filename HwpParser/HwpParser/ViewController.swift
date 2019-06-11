//
//  ViewController.swift
//  HwpParser
//
//  Created by LeeKyungjin on 22/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var vocablist = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = Bundle.main.url(forResource: "vocab", withExtension: "txt") {
            if let vocabs = try? String(contentsOf: url) {
                vocablist = vocabs.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\r\n")

                var refinedList = vocablist.filter {
                    $0.contains("접두어") == false &&
                    $0.contains("어근") == false &&
                    $0.isEmpty == false &&
                    $0.hasPrefix("\r\n") == false &&
                    $0.hasPrefix("\r") == false &&
                    $0.hasPrefix("\n") == false &&
                    $0.contains("Lesson") == false
                }
                
                refinedList.shuffle()
                
                let parsedString = refinedList.joined(separator: "\n")
                let filename = getDocumentsDirectory().appendingPathComponent("GongDanTo.txt")
                print("URL=\(filename)")
                do {
                    try parsedString.write(to: filename, atomically: true, encoding: .utf8)
                    print(parsedString)
                } catch {
                    print("Error writing")
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }


}

