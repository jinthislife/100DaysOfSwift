//
//  GameScene.swift
//  Project11
//
//  Created by LeeKyungjin on 12/04/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var editLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var ballCountLabel: SKLabelNode!
    var gameStatusLabel: SKLabelNode!

    var ballCount = 5 {
        didSet {
           ballCountLabel.text = "Ball x \(ballCount)"
        }
    }
    
    var editingMode = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        addBouncer(at: CGPoint(x: 0, y: 0))
        addBouncer(at: CGPoint(x: 256, y: 0))
        addBouncer(at: CGPoint(x: 512, y: 0))
        addBouncer(at: CGPoint(x: 768, y: 0))
        addBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        ballCountLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballCountLabel.text = "Ball x \(ballCount)"
        ballCountLabel.position = CGPoint(x: 530, y: 700)
        addChild(ballCountLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)

        let objects = nodes(at: location)
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
                let box = SKSpriteNode(color: color, size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                box.name = "bar"
                addChild(box)
            } else {
                guard location.y > 500 else { return }
                
                if ballCount == 0 {
                    gameOver()
                    return
                }
                
                let colors = ["Red", "Blue", "Green", "Yellow", "Cyan", "Purple", "Grey"]
                let ball = SKSpriteNode(imageNamed: "ball\(colors.randomElement()!)")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.width / 2.0)
                ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                ball.physicsBody!.restitution = 0.4 // bounce level
                ball.position = location
                ball.name = "ball"
                addChild(ball)
                ballCount -= 1
            }
        }
    }
    
    func gameOver() {
        gameStatusLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameStatusLabel.fontSize = 70
        gameStatusLabel.text = "GAME OVER"
        gameStatusLabel.position = CGPoint(x: 512, y: 384)
        addChild(gameStatusLabel)
    }
    
    func addBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        let slotBase: SKSpriteNode
        let slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false


        slotGlow.position = position

        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            ballCount += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        } else if object.name == "bar" {
            destory(bar: object)
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func destory(bar: SKNode) {
        if let sparkParticles = SKEmitterNode(fileNamed: "SparkParticles") {
            sparkParticles.position = bar.position
            addChild(sparkParticles)
        }
        bar.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node else { return }
        guard let bodyB = contact.bodyB.node else { return }
        if bodyA.name == "ball" {
            collisionBetween(ball: bodyA, object: bodyB)
        } else if bodyB.name == "ball" {
            collisionBetween(ball: bodyB, object: bodyA)
        }
    }
}
