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

    var cards = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let width = 160
        let height = 235
        
        /// Improvement needed
        let colors: [UIColor] = [.red, .yellow, .purple, .orange, .cyan, .blue, .magenta, .brown, .green]
        var pallete = colors + colors
        pallete.shuffle()

        for row in 0..<3 {
            for column in 0..<6 {
                let card = Card(frame: CGRect(x: 50 + column * (width + 10), y: 50 + row * (height + 10), width: width, height: height))
                card.flippedColor = pallete[row * 6 + column]
                card.backgroundColor = .gray
                card.layer.masksToBounds = true
                card.layer.cornerRadius = 10
                card.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
                cards.append(card)
                view.addSubview(card)
            }
        }
    }
    
    @objc func cardTapped(card: Card) {
        card.flipped = true

        var flippedCards = cards.filter { $0.flipped == true }
        
        if flippedCards.count == 2 {
            if flippedCards[0].backgroundColor == flippedCards[1].backgroundColor {
                // you got it! remove the pair and give score
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    flippedCards.forEach { $0.isHidden = true; $0.flipped = false }
                }
            } else {
                // turn back card
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    flippedCards.forEach { $0.flipped = false }
                }
            }
        }
    }


}

