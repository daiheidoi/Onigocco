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
        
        addChild(player)
    }
    
}
