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
    
    let scrambleMoves = 200
    var moves = 0 { didSet { outletMoveCounter.text =  "Moves: \(moves)"} }
    var timer = Timer()
    var timeElapsed = 0 {
        didSet {
            let minutes = timeElapsed / 60
            let seconds = timeElapsed % 60
            outletTimer.text = (seconds < 10) ? "Time \(minutes):0\(seconds)" : "Time \(minutes):\(seconds)"
        }
        
    }
    @IBOutlet weak var outletTimer: UILabel!
    @IBOutlet weak var outletMoveCounter: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Game View
        let boardRect = calculateBoardBounds()
        let tileSize = boardRect.width / CGFloat(boardSideLength)
        let tileRect = CGRect(x: 0, y: 0, width: tileSize, height: tileSize)
        
        
        for row in 0..<boardSideLength! {
            for column in 0..<boardSideLength! {
                
                // Creates all the buttons
                if column*boardSideLength+row != (boardSideLength*boardSideLength)-1 {
                    let button = UIButton()
                    button.bounds = tileRect
                    button.center = CGPoint(x: boardRect.origin.x + (CGFloat(column) + 0.5) * tileSize, y: boardRect.origin.y + (CGFloat(row) + 0.75)*tileSize)
                    let slicedImage = gameImage.slice(into: boardSideLength)
                
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
        
        scrambleBoard()
        
        // reset movecount and timer because scramble plays 200 moves
        moves = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.increaseElapsedTime), userInfo: nil, repeats: true)
    }
    
    
    // Scrambles by playing random moves
    func scrambleBoard() {
        // to increase entropy the last move cant be inverted
        var lastTileMoved = 0
        for _ in 0...scrambleMoves {
            // first, get the movable tiles
            var candidatesIndexes = [Int]()
            
            for tile in gameBoard.tiles {
                if gameBoard.isAdjacentToEmpty(tileIndex: tile.id), tile.id != lastTileMoved {
                    candidatesIndexes.append(tile.id)
                }
            }
            
            // then choose a candidate move and store it
            lastTileMoved = candidatesIndexes[Int.random(in: candidatesIndexes.count)]
            
            // then we move a random tiles
            gameButtons[lastTileMoved].sendActions(for: .touchUpInside)
        }
    }
    
    @objc func buttonDidTouch(_ sender: UIButton){
        if let oldPosition = gameBoard.getTile(at: sender.tag)?.position {
            
            if gameBoard.moveTile(withIndex: sender.tag) {
                
                // if the tile was moved in the model, move the button in the view
                if let newPosition = gameBoard.getTile(at: sender.tag)?.position {
                
                    if oldPosition.x == newPosition.x {
                        (newPosition.y - oldPosition.y) > 0 ? slideButton(buttonId: sender.tag, direction: "down") : slideButton(buttonId: sender.tag, direction: "up")
                    } else {
                        (newPosition.x - oldPosition.x) > 0 ? slideButton(buttonId: sender.tag, direction: "right") : slideButton(buttonId: sender.tag, direction: "left")
                    }
                }
                
                // check if the puzzle is solved
                print(gameBoard.checkIfSolved())
                
                // moveCounter
                moves += 1
                
                // timer
                print(timeElapsed)
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

    @objc func increaseElapsedTime() {
        timeElapsed += 1
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
