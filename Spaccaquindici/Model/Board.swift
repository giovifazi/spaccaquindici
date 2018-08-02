//
//  Board.swift
//  Spaccaquindici
//
//  Created by Giovi on 19/05/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import Foundation

struct Board {
    var sideLength: Int
    var tiles = [Tile]()
    var emptyTilePos: TilePosition
    var solvedState = [TilePosition]()
    
    init(sideLength: Int) {
        self.sideLength = sideLength
        
        // generates tiles in order
        for y in 0..<sideLength {
            for x in 0..<sideLength {
                if x != sideLength-1 || y != sideLength-1 {
                    let newPosition = TilePosition(x: x, y: y)
                    
                    // reset the tiles inital id to 0
                    var newTile: Tile
                    if x == 0, y == 0 {
                        newTile = Tile(atPosition: newPosition, resetFactory: true)
                    } else {
                        newTile = Tile(atPosition: newPosition, resetFactory: false)
                    }
                    
                    self.solvedState.append(newPosition)
                    self.tiles.append(newTile)
                }
            }
        }
        
        self.emptyTilePos = TilePosition(x: sideLength-1, y: sideLength-1)
    }
    
    func getTile(at tileNumber:Int) -> Tile? {
        return (tiles.indices.contains(tileNumber)) ? tiles[tileNumber] : nil
    }
    
    func getTile(x:Int, y:Int, width:Int) -> Tile? {
        let arrayIndex = y*width+x
        return getTile(at: arrayIndex)
    }
    
    func isAdjacentToEmpty(tileIndex:Int) -> Bool {
        if let tile = getTile(at: tileIndex) {

            let candidatePositions:[TilePosition] = [
                TilePosition(x: tile.position.x+1, y: tile.position.y),
                TilePosition(x: tile.position.x-1, y: tile.position.y),
                TilePosition(x: tile.position.x, y: tile.position.y+1),
                TilePosition(x: tile.position.x, y: tile.position.y-1)
            ]
            
                for candidate in candidatePositions {
                    if candidate == self.emptyTilePos {
                        return true
                    }
                }
        }
        return false
    }
    
    // Return true if the tile was moved
    mutating func moveTile(withIndex tileIndex: Int) -> Bool {
        
        // Check if tileIndex is adjacent to the empty tile
            if isAdjacentToEmpty(tileIndex: tileIndex) {
                let tmp = tiles[tileIndex].position
                tiles[tileIndex].position = self.emptyTilePos
                self.emptyTilePos = tmp
                
                return true
            }
        
        return false
    }
    
    func checkIfSolved() -> Bool {
        if self.emptyTilePos.x != sideLength-1 || self.emptyTilePos.y != sideLength-1 {
            return false
        }
        
        for tileIndex in 0..<solvedState.count {
            if tiles[tileIndex].position != solvedState[tileIndex] {
                return false
            }
        }
        
        return true
    }
    

}

extension Int {
    var isEven: Bool {
        if self%2 == 0 {
            return true
        } else {
            return false
        }
    }
    
    var isOdd: Bool {
        if self%2 != 0 {
            return true
        } else {
            return false
        }
    }
    
    static func random(in maxInt: Int) -> Int {
        return Int(arc4random_uniform(UInt32(maxInt)))
    }
}
