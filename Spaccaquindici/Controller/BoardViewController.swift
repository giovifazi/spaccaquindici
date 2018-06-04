//
//  BoardView.swift
//  Spaccaquindici
//
//  Created by Nate Higgers on 03/06/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit

class BoardViewController: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        let boardRect = calculateBoardBounds()
        let tileSize = boardRect.width / 4.0
        let tileBounds = CGRect(x: 0, y: 0, width: tileSize, height: tileSize)
        
//        for r in 0..<4 {
//            for c in 0..<4 {
//                let tile = board!.getTile(atRow: r, atColumn: c)
//                if tile > 0 {
//                    let button = self.viewWithTag(tile)
//                    button!.bounds = tileBounds
//                    button!.center =
//                        CGPoint(x: boardRect.origin.x + (CGFloat(c) + 0.5)*tileSize,
//                                y: boardRect.origin.y + (CGFloat(r) + 0.75)*tileSize)
//                }
//            }
//        }
    }
    
    func calculateBoardBounds() -> CGRect {
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let margin : CGFloat = 10
        
        let size = ((width <= height) ? width : height) - 2*margin
        
        let boardSize = CGFloat((Int(size) + 7)/8)*8.0
        
        let leftMargin = (width - boardSize)/2
        let topMargin = (height - boardSize)/2
        
        return CGRect(x: leftMargin, y: topMargin, width: boardSize, height: boardSize)
    }
}
