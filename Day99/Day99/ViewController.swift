//
//  ViewController.swift
//  Day99
//
//  Created by LeeKyungjin on 16/07/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit

class Card: UIButton {
    var flippedColor: UIColor = .red
    var paired: Bool = false
    var flipped: Bool = false {
        didSet {
            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

            UIView.transition(with: self, duration: 0.7, options: transitionOptions, animations: { [unowned self] in
                self.backgroundColor = self.flipped ? self.flippedColor : .gray
            })
        }
    }
}

class ViewController: UIViewController {

    let contents: [Content] = [
        .shape(.circle, .yellow),
        .shape(.triangle, .cyan),
        .shape(.square, .magenta),
        .emoji("🐶"),
        .emoji("🌺"),
        .emoji("💚")
    ]

    @IBOutlet var confettiView: ConfettiView!

    var cards = [Card]()
    var pairedCount = 0
    var elapsedTime = 0 {
        didSet {
            elapesedLabel.text = "\(elapsedTime) sec"
        }
    }
    
    var gameTimer: Timer!
    
    let timeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 850, y: 40, width: 80, height: 50))
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .darkGray
        label.text = "Time: "
        return label
    }()
    
    let elapesedLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 950, y: 40, width: 100, height: 50))
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .darkGray
        label.textAlignment = .right
        label.text = "\(0) sec"
        return label
    }()
    
    let clearedLabel: UILabel = {//!!!!!!! Can you use self inside lazy initialization?
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 800, height: 200))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 130, weight: .bold)
        label.text = "Cleared!"
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = 150
        let height = 215
        
        /// Improvement needed
        var colorPalette: [UIColor] = [.red, .red, .yellow, .yellow, .purple, .purple, .orange, .orange, .cyan, .cyan, .blue, .blue, .magenta,  .magenta, .brown, .brown, .green, .green]
        colorPalette.shuffle()

        for row in 0..<3 {
            for column in 0..<6 {
                let card = Card(frame: CGRect(x: 55 + column * (width + 20), y: 120 + row * (height + 20), width: width, height: height))
                card.flippedColor = colorPalette[row * 6 + column]
                card.backgroundColor = .gray
                card.layer.masksToBounds = true
                card.layer.cornerRadius = 10
                card.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
                cards.append(card)
                view.addSubview(card)
            }
        }
        view.addSubview(timeLabel)
        view.addSubview(elapesedLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(calculateTime), userInfo: nil, repeats: true)
    }
    
    @objc func calculateTime() {
        elapsedTime += 1
    }
    
    @objc func cardTapped(card: Card) {
        card.flipped = true

        var flippedCards = cards.filter { $0.flipped && !($0.paired) }
        
        if flippedCards.count == 2 {
            if flippedCards[0].backgroundColor == flippedCards[1].backgroundColor {
                // you got it! remove the pair and give score
                pairedCount += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    flippedCards.forEach { (card) in
                        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                                card.paired = true
                                card.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
                        }, completion: { _ in
                            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                                card.frame = CGRect(x: 55 + (50 + 10) * (self.pairedCount - 1), y: 40, width: 50, height: 50)
                                card.layer.cornerRadius = 24
                            }) { _ in
                                //check all cards are paired
                                if self.pairedCount == 9 {
                                    self.showGameClearedStatus()
                                }
                            }
                        })
                    }
                }
            } else {
                // turn back card
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    flippedCards.forEach { $0.flipped = false }
                }
            }
        }
    }

    func showGameClearedStatus() {
        gameTimer.invalidate()
        
        clearedLabel.center = view.center
        clearedLabel.isHidden = false

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.view.addSubview(self.clearedLabel)
            self.clearedLabel.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        }) { _ in
            self.confettiView.emit(with: self.contents)
        }
    }
}

