//
//  GameScene.swift
//  air-hockey
//
//  Created by Masaya Hayashi on 2017/07/13.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var main = SKSpriteNode()
    var enemy = SKSpriteNode()
    var ball = SKSpriteNode()

    override func didMove(to view: SKView) {
        self.main = childNode(withName: "main") as! SKSpriteNode
        self.main.position = CGPoint(x: 0, y: -self.frame.height / 2 + 50)
        self.main.size = CGSize(width: self.frame.width / 5, height: self.frame.width / 20)
        self.main.physicsBody = SKPhysicsBody(rectangleOf: self.main.frame.size)
        self.main.physicsBody?.affectedByGravity = false
        self.main.physicsBody?.allowsRotation = false
        self.main.physicsBody?.isDynamic = false
        self.enemy = childNode(withName: "enemy") as! SKSpriteNode
        self.enemy.position = CGPoint(x: 0, y: self.frame.height / 2 - 50)
        self.enemy.size = CGSize(width: self.frame.width / 5, height: self.frame.width / 20)
        self.enemy.physicsBody = SKPhysicsBody(rectangleOf: self.enemy.frame.size)
        self.enemy.physicsBody?.affectedByGravity = false
        self.enemy.physicsBody?.allowsRotation = false
        self.enemy.physicsBody?.isDynamic = false
        self.ball = childNode(withName: "ball") as! SKSpriteNode
        self.ball.setScale(self.frame.width / 400)

        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border

        self.ball.physicsBody?.applyImpulse(CGVector(dx: -30, dy: -30))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        movePaddles(with: touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        movePaddles(with: touches)
    }

    private func movePaddles(with touches: Set<UITouch>) {
        for touch in touches {
            let location = touch.location(in: self)
            main.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }

    override func update(_ currentTime: TimeInterval) {
        enemy.run(SKAction.moveTo(x: self.ball.position.x, duration: 0.2))
    }

}
