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
    
    static func != (lhs: TilePosition, rhs: TilePosition) -> Bool {
        return !(lhs == rhs)
    }
    
}

struct Tile {
    public private(set) var id: Int
    public var position: TilePosition
    private static var identifierFactory = -1
    
    init(atPosition position: TilePosition)
    {
        self.id = Tile.getUniqueIdentifier()
        self.position = position
    }
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}
