//
//  Board.swift
//  Spaccaquindici
//
//  Created by Nate Higgers on 19/05/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import Foundation

struct Board {
    var sideLength: Int
    var tiles = [Tile]()
    var emptyTile: TilePosition
    
    init(sideLength: Int) {
        self.sideLength = sideLength
        
        for x in 0..<sideLength {
            for y in 0..<sideLength {
                if x != sideLength-1 || y != sideLength-1 {
                    let newPosition = TilePosition(x: x, y: y)
                    let newTile = Tile(atPosition: newPosition)
                    self.tiles.append(newTile)
                }
            }
        }
        
        self.emptyTile = TilePosition(x: sideLength-1, y: sideLength-1)
    }
    
    func isSolvable() -> Bool {
        // get all inversion for every tile in tiles
        // ( (grid width odd) && (#inversions even) )  ||  ( (grid width even) && ((blank on odd row from bottom) == (#inversions even)) )
        // https://www.cs.bham.ac.uk/~mdr/teaching/modules04/java2/TilesSolvability.html
        var totalInversions = 0
        for tileIndex in 0..<tiles.count {
            totalInversions += getInversion(withIndexInTilesArray: tileIndex)
        }
        
        return ( (sideLength.isOdd) && (totalInversions.isEven) ||
                  )
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
}
