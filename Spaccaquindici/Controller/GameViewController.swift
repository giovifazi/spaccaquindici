//
//  GameViewController.swift
//  Spaccaquindici
//
//  Created by Giovi on 31/05/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var boardSideLength:Int!
    var gameBoard:Board!
    var gameImage:UIImage!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Game View
        let boardRect = calculateBoardBounds()
        let tileSize = boardRect.width / CGFloat(boardSideLength)
        let tileRect = CGRect(x: 0, y: 0, width: tileSize, height: tileSize)
        let slicedImage = gameImage.slice(into: boardSideLength)
        
        for row in 0..<boardSideLength! {
            for column in 0..<boardSideLength! {
                let button = UIButton()
                button.bounds = tileRect
                button.center = CGPoint(x: boardRect.origin.x + (CGFloat(column) + 0.5) * tileSize, y: boardRect.origin.y + (CGFloat(row) + 0.75)*tileSize)
                
                if column*boardSideLength+row == (boardSideLength*boardSideLength)-1 {
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    button.setBackgroundImage(slicedImage[row*boardSideLength!+column], for: UIControlState.normal)
                }
                
                self.view.addSubview(button)
            }
        }
        
        // Game Logic
        gameBoard = Board(sideLength: boardSideLength!)
        gameBoard.scrambleWithMoves()
        
        //TODO: fix scramble method
    }
    
    func calculateBoardBounds() -> CGRect {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let margin : CGFloat = 10
        
        let size = ((width <= height) ? width : height) - 2*margin
        
        let boardSize = CGFloat((Int(size) + 7)/8)*8.0
        
        let leftMargin = (width - boardSize)/2
        let topMargin = (height - boardSize)/2
        
        return CGRect(x: leftMargin, y: topMargin, width: boardSize, height: boardSize)
    }
}

// IMPORTANT: Assume that the image is always 480x480
extension UIImage {
    func slice(into sideLength: Int) -> [UIImage] {

        let tileSideLength = Int(480 / CGFloat(sideLength))
        
        var images = [UIImage]()
        
        let cgImage = self.cgImage!
    
        // Coords of the origin where the cropping rect starts
        var y = 0
        var x = 0
        
        for _ in 0 ..< sideLength {
            x=0
            for _ in 0 ..< sideLength {

                let tileRect = CGRect(x: x, y: y, width: tileSideLength, height: tileSideLength)
                let tileCgImage = cgImage.cropping(to: tileRect)!
                
                images.append(UIImage(cgImage: tileCgImage))
                x += tileSideLength
            }
            y += tileSideLength
        }
        return images
    }
}
