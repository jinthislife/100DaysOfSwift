//
//  GameScene.swift
//  Project26
//
//  Created by LeeKyungjin on 25/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import CoreMotion
import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case transport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var isGameOver = false
    var gameLevel = 1
    var transportPoints = [SKSpriteNode]()

    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
   
        loadLevel()
    }
    
    func loadLevel() {
        guard let levelUrl = Bundle.main.url(forResource: "level\(gameLevel)", withExtension: "txt") else {
            fatalError("Could not find level\(gameLevel).txt from the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelUrl) else {
            fatalError("Could not load level\(gameLevel).txt from the app bundle.")
        }
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        createPlayer()
        
        let lines = levelString.components(separatedBy: "\n")
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)

                if letter == "x" {
                    createWall(position: position)
                } else if letter == "v" {
                    createVortex(position: position)
                } else if letter == "s" {
                    createStar(position: position)
                } else if letter == "f" {
                    createFinishPoint(position: position)
                } else if letter == "t" {
                    createTransportPoint(position: position)
                } else if letter == " " {
                    // do nothing
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
//        if gameLevel == 1 {
//            player.position = CGPoint(x: 96, y: 96)
//        } else {
            player.position = CGPoint(x: 96, y: 672)
//        }
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    func createWall(position: CGPoint) {
        let node = createStaticNode(name: "block", position: position)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
    }

    func createVortex(position: CGPoint) {
        let node = createStaticNode(name: "vortex", position: position)
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
    }

    func createStar(position: CGPoint) {
        let node = createStaticNode(name: "star", position: position)
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
    }

    func createFinishPoint(position: CGPoint) {
        let node = createStaticNode(name: "finish", position: position)
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
    }

    func createTransportPoint(position: CGPoint) {
        let node = createStaticNode(name: "transport", position: position)
        node.physicsBody?.categoryBitMask = CollisionTypes.transport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        transportPoints.append(node)
    }
    
    func createStaticNode(name: String, position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: name)
        node.name = name
        node.position = position
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.isDynamic = false
        addChild(node)
        return node
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "transport" {
            let filteredArray = transportPoints.filter{ $0 !== node }
            guard let anotherTransportPoint = filteredArray.randomElement() else {
                assert(false, "Can not find anotherTransportPoint")
            }
            player.physicsBody?.isDynamic = false
            player.run(SKAction.scale(to: 0.0001, duration: 0.5)) { [weak anotherTransportPoint, weak self] in
                let transportPoint = CGPoint(x: anotherTransportPoint?.position.x ?? 96, y: (anotherTransportPoint?.position.y ?? 96) - 64)
                self?.player.position = transportPoint
                self?.player.run(SKAction.scale(to: 1, duration: 0.5))
                self?.player.physicsBody?.isDynamic = true
            }
        } else if node.name == "finish" {
            //next level
            node.run(SKAction.scale(to: 0.0001, duration: 0.5)) { [weak self, weak node] in
                node?.removeFromParent()
                self?.displayGameClearMessage()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.removeAllChildren()
                    self?.loadLevel()
                }
            }
        }
    }
    
    func displayGameClearMessage() {
        let labelBackgroundNode = SKSpriteNode(color: .black, size: CGSize(width: 1024, height: 150))
        labelBackgroundNode.position = CGPoint(x: 512, y: 384)
        labelBackgroundNode.zPosition = 2
        
        let gameClearedLabel = SKLabelNode(fontNamed: "Verdana-Bold") // 1. font
        gameClearedLabel.fontSize = 90
        gameClearedLabel.text = "Level\(gameLevel)  Cleared"
        gameClearedLabel.horizontalAlignmentMode = .center
        gameClearedLabel.position = CGPoint(x: 0, y: -30)
        gameClearedLabel.zPosition = 3
        labelBackgroundNode.addChild(gameClearedLabel)

        addChild(labelBackgroundNode)
        gameLevel += 1
    }
}
