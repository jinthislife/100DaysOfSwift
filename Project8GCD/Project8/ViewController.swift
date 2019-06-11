//
//  ViewController.swift
//  Project8
//
//  Created by LeeKyungjin on 04/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    let boarderWth: CGFloat = 0.5

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.text = "CLUES"
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)

        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.numberOfLines = 0
        view.addSubview(answersLabel)
        
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submit.layer.borderWidth = boarderWth
        submit.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clear.layer.borderWidth = boarderWth
        clear.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
//        buttonsView.backgroundColor = .green
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
         
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),

            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            // more constraints to come
        ])
//        cluesLabel.backgroundColor = .blue
//        answersLabel.backgroundColor = .red
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                letterButton.setTitle("WWW", for: .normal)

                letterButton.frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButton.layer.borderWidth = boarderWth
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    func loadLevel() {
        
        DispatchQueue.global().async { [weak self] in
            guard let weakSelf = self else { return }
            var clueString = ""
            var solutionString = ""
            var letterBits = [String]()

            if let levelUrl = Bundle.main.url(forResource: "level\(weakSelf.level)", withExtension: "txt") {
                if let levelContents = try? String(contentsOf: levelUrl) {
                    var lines = levelContents.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    for (index, line) in lines.enumerated() {
                        let parts = line.components(separatedBy: ": ")
                        let answer = parts[0]
                        let clue = parts[1]
                        
                        clueString += "\(index + 1). \(clue)\n"
                        
                        let solution = answer.replacingOccurrences(of: "|", with: "")
                        weakSelf.solutions.append(solution)
                        solutionString += "\(solution.count) letters\n"
                        
                        let bits = answer.components(separatedBy: "|")
                        letterBits += bits
                    }
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
                self?.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                letterBits.shuffle()
                
                if let buttonsCount = self?.letterButtons.count, letterBits.count == buttonsCount {
                    for i in 0..<buttonsCount {
                        self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                    }
                }
            }
        }
    }
    
    func isGameCleard() -> Bool {
        for btn in letterButtons {
            if btn.isHidden == false {
                return false
            }
        }
        return true
    }

    @objc func submitTapped(_ sender: UIButton) {
        guard let answer = currentAnswer.text else { return }
        if let position = solutions.firstIndex(of: answer) {
            activatedButtons.removeAll()

            var answers = answersLabel.text?.components(separatedBy: "\n")
            answers?[position] = solutions[position]
            answersLabel.text = answers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            if isGameCleard() {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }

        } else {
            let ac = UIAlertController(title: "Wrong answer!", message: "Try again!", preferredStyle: . alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            score -= 1
            clear()
        }
    }
    
    func clear() {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        clear()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let letter = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(letter)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
}

