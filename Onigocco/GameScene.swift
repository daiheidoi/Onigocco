//
//  GameScene.swift
//  Onigocco
//
//  Created by 土井大平 on 2017/01/30.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    /// プレイヤー
    let player = SKShapeNode(circleOfRadius: 10)
    
    /// 複数の敵
    var enemies = [SKShapeNode]()
    
    /// タイマー
    var timer : Timer?
    
    /// 前回インターバル
    var prevTime: TimeInterval = 0
    
    /// View置かれた際に呼ばれるメソッド
    ///
    /// - Parameter view: ビュー
    override func didMove(to view: SKView) {
        
        /// プレイヤー黄色にしておく
        player.fillColor = UIColor.yellow;
        
        /// シーンにaddChild
        addChild(player)
        
        /// 敵生成タイマー設定
        setCreateTimer()
        
        /// Gravityを初期化しておく
        physicsWorld.gravity = CGVector()
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
            player.run(SKAction.follow(path, speed: 10.0))
        }
    }
    
    /// タイマー生成、設定
    private func setCreateTimer() {
        /// タイマー初期化
        timer?.invalidate()
        
        /// タイマー設定
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(GameScene.createEnemy), userInfo: nil, repeats: true)
        
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
                $0.run(SKAction.follow(path, speed: 20.0))
            }
        }
        /// 保持時間更新
        prevTime = currentTime
    }
}
