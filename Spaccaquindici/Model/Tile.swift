//
//  Tile.swift
//  Spaccaquindici
//
//  Created by Giovi on 19/05/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import Foundation

struct TilePosition {
    var x: Int
    var y: Int
}

extension TilePosition {
    static func == (lhs: TilePosition, rhs: TilePosition) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
}

struct Tile {
    public private(set) var id: Int
    public private(set) var position: TilePosition
    private static var identifierFactory = 0
    
    init(atPosition position: TilePosition)
    {
        self.id = Tile.getUniqueIdentifier()
        self.position = position
    }
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    mutating func moveLeft() {
        self.position.x >= 1 ? self.position.x -= 1 : nil
    }
    
    mutating func moveRight(withoutExcedingColumn limit: Int) {
        self.position.x <= limit-1 ? self.position.x += 1 : nil
    }
    
    mutating func moveUp() {
        self.position.y >= 1 ? self.position.y -= 1 : nil
    }
    
    mutating func moveDown(withoutExcedingRow limit: Int) {
        self.position.y <= limit-1 ? self.position.y += 1 : nil
    }
}
