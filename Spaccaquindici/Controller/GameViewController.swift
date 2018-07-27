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
    var gameButtons = [UIButton]()
    var gameImage:UIImage!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrambleBoard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Game View
        let boardRect = calculateBoardBounds()
        let tileSize = boardRect.width / CGFloat(boardSideLength)
        let tileRect = CGRect(x: 0, y: 0, width: tileSize, height: tileSize)
        let slicedImage = gameImage.slice(into: boardSideLength)
        
        for row in 0..<boardSideLength! {
            for column in 0..<boardSideLength! {
                // Creates all the buttons
                if column*boardSideLength+row != (boardSideLength*boardSideLength)-1 {
                    let button = UIButton()
                    button.bounds = tileRect
                    button.center = CGPoint(x: boardRect.origin.x + (CGFloat(column) + 0.5) * tileSize, y: boardRect.origin.y + (CGFloat(row) + 0.75)*tileSize)
                
                    button.setBackgroundImage(slicedImage[row*boardSideLength!+column], for: UIControlState.normal)
                
                    self.view.addSubview(button)
                    button.tag = row*boardSideLength+column
                    gameButtons.append(button)
                }
            }
        }
        
        // Associate buttons to touch event target
        for index in 0..<gameButtons.count {
            gameButtons[index].addTarget(self, action: #selector(GameViewController.buttonDidTouch(_:)), for: .touchUpInside)
        }
        
        // Game Logic
        gameBoard = Board(sideLength: boardSideLength!)
    
        print(gameBoard.checkIfSolved())
    }
    
    func scrambleBoard() {
        for _ in 0...1000 {
            gameButtons[Int.random(in: boardSideLength*boardSideLength-1)].sendActions(for: .touchUpInside)
        }
    }
    
    @objc func buttonDidTouch(_ sender: UIButton){
        let oldPosition = gameBoard.getTile(at: sender.tag).position
        
        if gameBoard.moveTile(withIndex: sender.tag) {
            
            let newPosition = gameBoard.getTile(at: sender.tag).position
            
            if oldPosition.x == newPosition.x {
                (newPosition.y - oldPosition.y) > 0 ? slideButton(buttonId: sender.tag, direction: "down") : slideButton(buttonId: sender.tag, direction: "up")
            } else {
                (newPosition.x - oldPosition.x) > 0 ? slideButton(buttonId: sender.tag, direction: "right") : slideButton(buttonId: sender.tag, direction: "left")
            }
            
        }
    }
    
    func slideButton(buttonId id:Int, direction: String) {
        
        switch direction {
        case "up":
            gameButtons[id].center.y -= gameButtons[id].bounds.size.height
        case "down":
            gameButtons[id].center.y += gameButtons[id].bounds.size.height
        case "right":
            gameButtons[id].center.x += gameButtons[id].bounds.size.width
        case "left":
            gameButtons[id].center.x -= gameButtons[id].bounds.size.width
        default:
            return
        }
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
