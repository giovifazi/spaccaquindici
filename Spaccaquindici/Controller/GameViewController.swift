//
//  GameViewController.swift
//  Spaccaquindici
//
//  Created by Giovi on 31/05/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var boardSideLength:Int?
    var gameBoard:Board?
    var boardRect:CGRect
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Game View
        boardRect = calculateBoardBounds()
        let tileSize = boardRect.width / CGFloat(boardSideLength ?? 4)
        let tileRect = CGRect(x: 0, y: 0, width: tileSize, height: tileSize)
        
        for row in 0..<
        
        // Game Logic
        gameBoard = Board(sideLength: boardSideLength ?? 4)
        
    
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

