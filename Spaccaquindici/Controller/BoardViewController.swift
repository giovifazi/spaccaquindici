//
//  BoardView.swift
//  Spaccaquindici
//
//  Created by Giovi on 03/06/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit

class BoardViewController: UIView {

    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let boardRect = calculateBoardBounds()
        let tileSize = boardRect.width / 4.0
        let tileBounds = CGRect(x: 0, y: 0, width: tileSize, height: tileSize)
        
        var gameBoard = Board(sideLength: 4)
        
//        for row in 0..<4 {
//            for column in 0..<4 {
//                let tile = gameBoard.getTile(atRow: row, atColumn: column)
//                if tile > 0 {
//                    let button = self.viewWithTag(tile)
//                    button!.bounds = tileBounds
//                    button!.center =
//                        CGPoint(x: boardRect.origin.x + (CGFloat(column) + 0.5)*tileSize,
//                                y: boardRect.origin.y + (CGFloat(row) + 0.75)*tileSize)
//                }
//            }
//        }
    }
    

}
