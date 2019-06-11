//
//  ViewController.swift
//  Project5
//
//  Created by LeeKyungjin on 30/03/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer) )
        
        if let url = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let contents = try? String(contentsOf: url) {
                allWords = contents.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty == true {
           allWords = ["silkworm"]
        }

        if let lastWord = UserDefaults.standard.value(forKey: "word") as? String {
            title = lastWord
            usedWords = UserDefaults.standard.value(forKey: "answers") as? [String] ?? [String]()
        } else {
            startGame()
        }
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func saveLast() {
        UserDefaults.standard.set(title, forKey: "word")
        UserDefaults.standard.set(usedWords, forKey: "answers")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }

        for letter in word {
            if let index = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if word.count < 3 {
            return false
        }

        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func isNotSame(word: String) -> Bool {
        guard let title = title else { return true }
        
        if word.compare(title) == .orderedSame {
            return false
        }

        return true
    }
    
    func submit(_ answer: String) {
        let lowerCasedAnswer = answer.lowercased()

        if isNotSame(word: lowerCasedAnswer) {
            if isPossible(word: lowerCasedAnswer) {
                if isOriginal(word: lowerCasedAnswer) {
                    if isReal(word: lowerCasedAnswer) {
                        usedWords.insert(lowerCasedAnswer, at: 0)
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        saveLast()
                        return
                    } else {
                        showErrorAlert(title: "Word not recognised", message: "You can't just make them up, you know!")
                    }
                } else {
                    showErrorAlert(title: "Word used already", message: "Be more original!")
                }
            } else {
                guard let title = title?.lowercased() else { return }
                showErrorAlert(title: "Word not possible", message: "You can't spell that word from \(title)")
            }
        } else {
            showErrorAlert(title: "Same word used", message: "Be more creative!")
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}

