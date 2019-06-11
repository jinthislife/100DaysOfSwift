//
//  ViewController.swift
//  Project2
//
//  Created by LeeKyungjin on 21/03/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var progressLabel: UILabel!
    
    let maxQuestionNumber = 10
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var askedQuestionNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        if askedQuestionNumber > maxQuestionNumber {
            showFinalScore()
            return
        }

        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        title = "\(countries[correctAnswer].uppercased()) (Score: \(score))"
        
        progressLabel.text = "\(askedQuestionNumber) / 10"
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    func showFinalScore() {
        let ac = UIAlertController(title: "Game Over", message: "Your final score is \(score)!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String = ""
        var resultMessage: String = ""
        askedQuestionNumber += 1
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)}) { finished in
                sender.transform = .identity
                if sender.tag == self.correctAnswer {
                    title = "Correct!"
                    self.score += 1
                } else {
                    title = "Wrong!"
                    resultMessage = "That's the flag of \(self.countries[sender.tag].uppercased()).\n"
                    self.score -= 1
                }
                
                self.title = "\(self.countries[self.correctAnswer].uppercased()) (Score: \(self.score))"
                
                let ac = UIAlertController(title: title, message: "\(resultMessage)Your score is \(self.score).", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: self.askQuestion))
                self.present(ac, animated: true)
        }
    }
}

