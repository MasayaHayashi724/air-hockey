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

    private var main = SKSpriteNode()
    private var enemy = SKSpriteNode()
    private var ball = SKSpriteNode()
    private var mainScore = SKLabelNode()
    private var enemyScore = SKLabelNode()

    var VC: GameViewController!
    var difficulty: Difficulty = .medium
    var gameIsFinished: Bool {
        guard let mainScoreStr = mainScore.text else { return false }
        guard let enemyScoreStr = enemyScore.text else { return false }
        guard let mainScore = Int(mainScoreStr) else { return false }
        guard let enemyScore = Int(enemyScoreStr) else { return false }
        return (mainScore == 5) || (enemyScore == 5)
    }

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
        self.mainScore = childNode(withName: "mainScore") as! SKLabelNode
        self.enemyScore = childNode(withName: "enemyScore") as! SKLabelNode

        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border

        startGame()
    }

    private func startGame() {
        self.ball.position = CGPoint.zero
        self.ball.physicsBody?.velocity = CGVector.zero
        let angle = randomValue(between: 0, and: 2 * Double.pi)
        let impulseValue = Double(self.frame.width / 15)
        let dx = impulseValue * cos(angle)
        let dy = impulseValue * sin(angle)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.ball.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        }
    }

    func randomValue(between min: Double, and max: Double) -> Double {
        let random = Double(arc4random_uniform(UINT32_MAX)) / Double(UINT32_MAX)
        return random * (max - min) + min
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
        switch difficulty {
        case .easy:
            enemy.run(SKAction.moveTo(x: self.ball.position.x, duration: 0.3))
        case .medium:
            enemy.run(SKAction.moveTo(x: self.ball.position.x, duration: 0.2))
        case .hard:
            enemy.run(SKAction.moveTo(x: self.ball.position.x, duration: 0.1))
        }

        if ball.position.y <= self.main.position.y - 10 {
            addScore(to: enemyScore)
            return
        }
        if ball.position.y >= self.enemy.position.y + 10 {
            addScore(to: mainScore)
            return
        }

    }

    private func addScore(to scoreLabel: SKLabelNode) {
        guard let text = scoreLabel.text else { return }
        guard let score = Int(text) else { return }
        scoreLabel.text = String(score + 1)
        if gameIsFinished {
            endGame()
        } else {
            startGame()
        }
    }

    private func endGame() {
        self.ball.position = .zero
        self.ball.physicsBody?.velocity = .zero
        guard let mainScoreStr = mainScore.text else { return }
        guard let enemyScoreStr = enemyScore.text else { return }
        guard let mainScore = Int(mainScoreStr) else { return }
        guard let enemyScore = Int(enemyScoreStr) else { return }
        if mainScore > enemyScore {
            showResultLabel(text: "You Win!")
        } else {
            showResultLabel(text: "You Lose...")
        }
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            self.VC.navigationController?.popViewController(animated: true)
        }
    }

    private func showResultLabel(text: String) {
        self.mainScore.isHidden = true
        self.enemyScore.isHidden = true
        self.ball.isHidden = true
        let resultLabel = SKLabelNode(text: text)
        resultLabel.fontName = "Chalkboard SE"
        resultLabel.fontSize = 100
        resultLabel.fontColor = .white
        resultLabel.position = .zero
        self.addChild(resultLabel)
    }

}
