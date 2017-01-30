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
    
    
    /// View置かれた際に呼ばれるメソッド
    ///
    /// - Parameter view: ビュー
    override func didMove(to view: SKView) {
        
        /// プレイヤー黄色にしておく
        player.fillColor = UIColor.yellow;
        
        /// シーンにaddChild
        addChild(player)
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
            player.run(SKAction.follow(path, speed: 50.0))
        }
    }
}
