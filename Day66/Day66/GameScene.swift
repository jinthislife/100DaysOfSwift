//
//  GameScene.swift
//  Day66
//
//  Created by LeeKyungjin on 06/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var gameTimer: Timer?
    var scoreLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }
    
    var timeRemained = 60 {
        didSet {
            timeLabel?.text = "\(timeRemained) sec"
        }
    }
    
    let possibleTargets = ["ball", "hammer", "tv", "penguinGood"]
    
    override func didMove(to view: SKView) {
        //draw background
        let titleBox = SKSpriteNode(color: .blue, size: CGSize(width: 1024, height: 158))
        titleBox.position = CGPoint(x: 512, y: 79)
        
        addChild(titleBox)

        let dividerBox2 = SKSpriteNode(color: .blue, size: CGSize(width: 1024, height: 30))
        dividerBox2.position = CGPoint(x: 512, y: 158 + 150 + 15)
        addChild(dividerBox2)
        
        let dividerBox1 = SKSpriteNode(color: .blue, size: CGSize(width: 1024, height: 30))
        dividerBox1.position = CGPoint(x: 512, y: 158 + 150 + 30 + 150 + 15)
        addChild(dividerBox1)
        
        let scoreBox = SKSpriteNode(color: .blue, size: CGSize(width: 1024, height: 100))
        scoreBox.position = CGPoint(x: 512, y: 158+150+30+150+30+150+50)
        addChild(scoreBox)
        
//        let leftEdge = SKSpriteNode(color: .blue, size: CGSize(width: 30, height: 768))
//        leftEdge.position = CGPoint(x: 15, y: 384)
//        leftEdge.zPosition = 1
//        addChild(leftEdge)
//
//        let rightEdge = SKSpriteNode(color: .blue, size: CGSize(width: 30, height: 768))
//        rightEdge.position = CGPoint(x: 1009, y: 384)
//        rightEdge.zPosition = 1
//        addChild(rightEdge)
        
        //create score and timelabel
        scoreLabel = SKLabelNode(fontNamed: UIFont(name: "TimesNewRomanPSMT", size: 100)?.fontName)
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: 200, y: 710)
        addChild(scoreLabel)
        
        timeLabel = SKLabelNode(fontNamed: UIFont(name: "TimesNewRomanPSMT", size: 100)?.fontName)
        timeLabel.text = "60 sec"
        timeLabel.fontSize = 50
        timeLabel.position = CGPoint(x: 850, y: 710)
        addChild(timeLabel)

        let titleLabel = SKLabelNode(fontNamed: UIFont(name: "TimesNewRomanPSMT", size: 100)?.fontName)
        titleLabel.text = "SHOOTING GALLERY"
        titleLabel.fontSize = 80
        titleLabel.position = CGPoint(x: 512, y: 50)
        addChild(titleLabel)
        //create timer
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
    }
    
    func finishGame() {
        gameTimer?.invalidate()
        let gameoverLabel = SKLabelNode(fontNamed: "TimesNewRomanPSMT")
        gameoverLabel.text = "Game Over"
        gameoverLabel.fontSize = 100
        gameoverLabel.fontColor = .black
        gameoverLabel.position = CGPoint(x: 512, y: 384)
        gameoverLabel.zPosition = 1
        addChild(gameoverLabel)
    }
    
    @objc func createTarget() {
        if timeRemained <= 0 {
            finishGame()
            return
        }
        
        timeRemained -= 1

        guard let target = possibleTargets.randomElement() else { return
        }
        let sprite = SKSpriteNode(imageNamed: target)
        sprite.name = target
        let moveToLeft = SKAction.moveBy(x: -1200, y: 0, duration: 6.0)
        let moveToRight = SKAction.moveBy(x: 1200, y: 0, duration: 6.0)
        
        let rowPosY: [CGFloat] = [158, 338, 518]
        
        if let posY = rowPosY.randomElement() {
            if posY == 338 {
                sprite.position = CGPoint(x: -100, y: posY + sprite.size.height/2.0)
                addChild(sprite)
                sprite.run(moveToRight)
            } else {
                sprite.position = CGPoint(x: 1100, y: posY + sprite.size.height/2.0)
                addChild(sprite)
                sprite.run(moveToLeft)
            }
        }
    }
    
    func showPointLabel(at location: CGPoint, point: Int) {
        let label = SKLabelNode(fontNamed: UIFont(name: "TimesNewRomanPSMT", size: 100)?.fontName)
        label.fontColor = .blue
        label.text = "+\(point)"
        label.position = location
        label.zPosition = 1
        addChild(label)
        
        label.run(SKAction.moveBy(x: 0, y: 60, duration: 0.5))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak label] in
            label?.removeFromParent()
        }
    }

    func showWarnLabel(at location: CGPoint) {
        let label = SKLabelNode(fontNamed: UIFont(name: "TimesNewRomanPSMT", size: 100)?.fontName)
        label.numberOfLines = 0
        label.fontColor = .red
        label.text = "-5\nDon't shoot me!"
        label.position = location
        label.zPosition = 1
        addChild(label)
        
        label.run(SKAction.moveBy(x: 0, y: 60, duration: 0.5))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak label] in
            label?.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node.name == "ball" || node.name == "hammer" || node.name == "tv" {
                if let emitter = SKEmitterNode(fileNamed: "SparkParticles") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                if node.name == "hammer" {
                    score += 20
                    showPointLabel(at: node.position, point: 20)
                } else {
                    score += 5
                    showPointLabel(at: node.position, point: 5)
                }
                node.removeFromParent()

            } else if node.name == "penguinGood" {
                showWarnLabel(at: node.position)
                score -= 5
//                if let emitter = SKEmitterNode(fileNamed: "smoke") {
//                    emitter.position = node.position
//                    emitter.run(<#T##action: SKAction##SKAction#>)
//                    addChild(emitter)
//                }
            }
        }
        
    }

}
