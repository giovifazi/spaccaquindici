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
    var emptyTile: TilePosition
    
    init(sideLength: Int) {
        self.sideLength = sideLength
        
        for y in 0..<sideLength {
            for x in 0..<sideLength {
                if x != sideLength-1 || y != sideLength-1 {
                    let newPosition = TilePosition(x: x, y: y)
                    let newTile = Tile(atPosition: newPosition)
                    self.tiles.append(newTile)
                }
            }
        }
        
        self.emptyTile = TilePosition(x: sideLength-1, y: sideLength-1)
    }
    
    func getTile(at tileNumber:Int) -> Tile {
        if tileNumber >= 0, tileNumber <= 15 {
            return tiles[tileNumber]
        } else {
            return tiles[0]
        }
    }
    
    func getTile(x:Int, y:Int, width:Int) -> Tile {
        let arrayIndex = y*width+x
        if tiles.indices.contains(arrayIndex) {
            return tiles[arrayIndex]
        } else {
            return tiles[0]
        }
    }
    
    // Return true if the tile was moved
    mutating func moveTile(withIndex tileIndex: Int) -> Bool {
        // Check if tileIndex is a movable tile
        let candidatesTiles:[TilePosition] = [TilePosition(x: emptyTile.x-1, y: emptyTile.y),
                                              TilePosition(x: emptyTile.x+1, y: emptyTile.y),
                                              TilePosition(x: emptyTile.x, y: emptyTile.y+1),
                                              TilePosition(x: emptyTile.x, y: emptyTile.y-1)
        ]
        
        for candidateIndex in 0..<candidatesTiles.count {
            if (tiles[tileIndex].position == candidatesTiles[candidateIndex]) {
                let tmp = tiles[tileIndex].position
                tiles[tileIndex].position = emptyTile
                emptyTile = tmp
                
                return true
            }
        }
        
        return false
    }
    
    func isSolvable() -> Bool {
        // ( (grid width odd) && (#inversions even) )  ||  ( (grid width even) && ((blank on odd row from bottom) == (#inversions even)) )
        // https://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html
        var totalInversions = 0
        for tileIndex in 0..<tiles.count {
            totalInversions += getInversion(withIndexInTilesArray: tileIndex)
        }
        
        return ( ((sideLength.isOdd) && (totalInversions.isEven)) || ( (sideLength.isEven) && (emptyTile.y.isOdd) == (totalInversions.isEven)))
    }
    
    private func getInversion(withIndexInTilesArray id: Int) -> Int {
        if id == tiles.count-1 {
            return 0
        }
        
        var inversions = 0
        for compareIndex in id+1..<tiles.count {
            if tiles[compareIndex].id < tiles[id].id {
                inversions += 1
            }
        }
        
        return inversions
    }
    
    func scramble() {}
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
