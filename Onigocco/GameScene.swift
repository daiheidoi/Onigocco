//
//  GameScene.swift
//  Onigocco
//
//  Created by 土井大平 on 2017/01/30.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import SpriteKit
import GameplayKit


/// 衝突判定bit
private struct CollisionType {
    static let player: UInt32 = 1 << 0 // 001
    static let enemy: UInt32 = 1 << 1 // 010
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /// プレイヤー
    let player = SKShapeNode(circleOfRadius: 10)
    
    /// 複数の敵
    var enemies = [SKShapeNode]()
    
    /// タイマー
    var timer : Timer?
    
    /// 前回インターバル
    var prevTime: TimeInterval = 0
    
    /// 記録時間
    var startTime: TimeInterval = 0
    
    /// ゲーム終了フラグ
    var isGameFinished = false
    
    /// View置かれた際に呼ばれるメソッド
    ///
    /// - Parameter view: ビュー
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        /// プレイヤー黄色にしておく
        player.fillColor = UIColor.yellow;
        
        /// 衝突判定用bit追加
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width / 2)
        player.physicsBody?.categoryBitMask = CollisionType.player
        player.physicsBody?.contactTestBitMask = CollisionType.enemy
        /// シーンにaddChild
        addChild(player)
        
        /// 敵生成タイマー設定
        setCreateTimer()
        
        /// Gravityを初期化しておく
        self.physicsWorld.gravity = CGVector()
    }
    
    
    /// タッチ終了時に呼ばれるメソッド
    ///
    /// - Parameters:
    ///   - touches: タッチのインスタンス(複数あり)
    ///   - event: イベント
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /// タッチのインスタンス文for
        touches.forEach {
            
            /// 位置取得
            let point = $0.location(in: self)
            
            /// playerが持つアクションを一旦全削
            player.removeAllActions()
            
            /// タッチ位置と現playerのパス構築
            let path = CGMutablePath()
            path.move(to: CGPoint())
            path.addLine(to: CGPoint(x: point.x - player.position.x, y: point.y - player.position.y))
            
            /// followアクション追加
            player.run(SKAction.follow(path, speed: 200.0))
        }
    }
    
    /// タイマー生成、設定
    private func setCreateTimer() {
        /// タイマー初期化
        timer?.invalidate()
        
        /// タイマー設定
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(GameScene.createEnemy), userInfo: nil, repeats: true)
        
        /// fire
        timer?.fire()
    }
    
    /// 敵生成
    @objc private func createEnemy() {
        
        /// 敵生成
        let enemy = SKShapeNode(circleOfRadius: 10)
        enemy.position.x = size.width / 2
        enemy.fillColor = UIColor.red
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.frame.width / 2)
        /// 衝突判定用bit追加
        enemy.physicsBody?.categoryBitMask = CollisionType.enemy
        enemy.physicsBody?.contactTestBitMask = CollisionType.player
        addChild(enemy)
        
        /// 監視配列に追加
        enemies.append(enemy)
    }
    
    
    /// 更新処理メソッド(FPSごとに呼ばれる)
    ///
    /// - Parameter currentTime: インターバル
    override func update(_ currentTime: TimeInterval) {
        
        if prevTime == 0 {
            /// 時間保持(初期化時)
            prevTime = currentTime
            startTime = currentTime
        }
        
        /// プレイヤの位置監視(一秒ごと)
        if Int(currentTime) != Int(prevTime) {
            enemies.forEach {
                /// 一旦アクション全削除
                $0.removeAllActions()
                
                /// 追跡パス生成
                let path = CGMutablePath()
                path.move(to: CGPoint())
                path.addLine(to: CGPoint(x: player.position.x - $0.position.x, y: player.position.y - $0.position.y))
                
                /// アクション追加
                $0.run(SKAction.follow(path, speed: 150.0))
            }
        }
        
        /// 保持時間更新
        prevTime = currentTime
    }
    
    
    /// 衝突監視メソッド
    ///
    /// - Parameter contact: コンタクト
    func didBegin(_ contact: SKPhysicsContact) {
        
        let player_enemy = CollisionType.player | CollisionType.enemy // 110
        
        /// 衝突ノードの和
        let check = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        /// 判定
        if player_enemy == check && !isGameFinished {
            /// ゲーム終了処理
            isGameFinished = true
            timer?.invalidate()
            let label = SKLabelNode(text: "記録:\(Int(prevTime - startTime))秒")
            label.fontSize = 80
            label.position = CGPoint(x: 0, y: -100)
            addChild(label)
        }
    }
}
