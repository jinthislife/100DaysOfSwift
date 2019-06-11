//
//  ViewController.swift
//  Hangman_Day41
//
//  Created by LeeKyungjin on 07/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var chanceLeft = 7 {
        didSet {
            title = "\(String(promptWord)) (Chance: \(chanceLeft))"
        }
    }

    var words: [String]!
    var currentWord: String!
    var usedLetters = [Character]()
    
    var promptWord = "" {
        didSet {
            title = "\(String(promptWord)) (Chance: \(chanceLeft))"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Answer", style: .plain, target: self, action: #selector(answerTapped))

        if let fileUrl = Bundle.main.url(forResource: "word", withExtension: "txt") {
            if let wordString = try? String(contentsOf: fileUrl) {
                words = wordString.components(separatedBy: "\n")
                currentWord = words.randomElement()?.uppercased()
                for _ in 1...currentWord.count {
                    promptWord += "?"
                }
            }
        }
    }
    
    func isAlreadyUsedLetter(_ letter: Character) -> Bool {
        return usedLetters.contains(letter)
    }
    
    func isWrongLetter(_ letter: Character)  -> Bool {
        return !currentWord.contains(letter)
    }
    
    func checkLetter(_ letter: Character) {
        if isAlreadyUsedLetter(letter) {
            chanceLeft -= 1
            let ac = UIAlertController(title: "You alreday used \(letter)", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        if isWrongLetter(letter) {
            chanceLeft -= 1
            let ac = UIAlertController(title: "Wrong letter. Guess again!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        usedLetters.append(letter)
        
        var tempPromptWord = ""
        for c in currentWord {
            if usedLetters.contains(c) {
                tempPromptWord.append(c)
            } else {
                tempPromptWord.append("?")
            }
        }
        promptWord = tempPromptWord

        if promptWord.contains("?") == false {
            //show clear alert
            let ac = UIAlertController(title: "Congrat!", message: "Game Cleared", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func answerTapped() {
        let ac = UIAlertController(title: "Guess one letter in the word", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: { (textField) in
            if let text = textField.text, text.count > 1 {
                textField.deleteBackward()
            }
        })
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let text = ac.textFields?[0].text else { return }
            self.checkLetter(Character(text.uppercased()))
        }))
        present(ac, animated: true)
    }
    
}

