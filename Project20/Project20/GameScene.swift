//
//  GameScene.swift
//  Project20
//
//  Created by LeeKyungjin on 10/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer!
    var fireworks = [SKNode]()
    var scoreLabel: SKLabelNode!
    var restartLabel: SKLabelNode!
    var gameoverLabel: SKLabelNode!
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    var gameLeftCount = 1
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.blendMode = .replace
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Verdana")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: 870, y: 710)
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }

    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800

        if gameLeftCount <= 0 {
            gameTimer?.invalidate()
            gameTimer = nil
            gameoverLabel = SKLabelNode(fontNamed: "Verdana-Bold")
            gameoverLabel.fontColor = .white
            gameoverLabel.fontSize = 90
            gameoverLabel.position = CGPoint(x: 512, y: 384)
            gameoverLabel.text = "GAME OVER"
            addChild(gameoverLabel)
            
            restartLabel = SKLabelNode(fontNamed: "Verdana")
            restartLabel.fontColor = .yellow
            restartLabel.fontSize = 35
            restartLabel.position = CGPoint(x: 512, y: 290)
            restartLabel.text = "Try Again"
            addChild(restartLabel)
            
            let fadeIn = SKAction.fadeIn(withDuration: 0.5)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let blinkSequence = SKAction.sequence([fadeIn, fadeOut])
            let blink = SKAction.repeatForever(blinkSequence)
            restartLabel.run(blink)
            return
        }

        gameLeftCount -= 1

        switch Int.random(in: 0...3) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
            
        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            
        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            
        default:
            break
        }
    }

    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        if let _ = gameTimer?.isValid {
            for case let node as SKSpriteNode in nodesAtPoint {
                guard node.name == "firework" else { continue }

                for parent in fireworks {
                    guard let firework = parent.children.first as? SKSpriteNode else { continue }
                    
                    if firework.name == "selected" && firework.color != node.color {
                        firework.name = "firework"
                        firework.colorBlendFactor = 1
                    }
                }
                node.name = "selected"
                node.colorBlendFactor = 0
            }
        } else {
            if nodesAtPoint.contains(restartLabel) {
                gameoverLabel.removeFromParent()
                restartLabel.removeFromParent()
                gameLeftCount = 1
                gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)

                let fadeOut = SKAction.fadeOut(withDuration: 1)
                let fadeIn = SKAction.fadeIn(withDuration: 0)
                let sequence = SKAction.sequence([fadeOut, fadeIn])
//                let fadeOut = SKAction.fadeAlpha(by: -0.9, duration: 0)
//                let fadeIn = SKAction.fadeAlpha(by: 1, duration: 1)
                
                self.scene?.run(sequence)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }
        
        firework.removeFromParent()
    }

    func explodeFireworks() {
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                // destroy this firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0:
            // nothing – rubbish!
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
