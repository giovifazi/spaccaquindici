//
//  Achievements.swift
//  Spaccaquindici
//
//  Created by Giovi on 16/08/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import Foundation

let emptyAchievements = "000000000000000000000000" //24 achievements
let achievementsDescription = [
    "Finish a 4x4 puzzle",
    "Finish a 5x5 puzzle",
    "Finish a 6x6 puzzle",
    
    // 4x4
    "Finish a 4x4 puzzle under 10 min", // [3]
    "Finish a 4x4 puzzle under 5 min",
    "Finish a 4x4 puzzle under 2 min",
    "Finish a 4x4 puzzle under 1 min",
    
    "Finish a 4x4 puzzle within 300 moves", // [7]
    "Finish a 4x4 puzzle within 200 moves",
    "Finish a 4x4 puzzle within 100 moves",
    
    // 5x5
    "Finish a 5x5 puzzle under 10 min", // [10]
    "Finish a 5x5 puzzle under 5 min",
    "Finish a 5x5 puzzle under 2:30 min",
    "Finish a 5x5 puzzle under 2 min",
    
    "Finish a 5x5 puzzle within 400 moves", // [14]
    "Finish a 5x5 puzzle within 300 moves",
    "Finish a 5x5 puzzle within 275 moves",
    
    // 6x6
    "Finish a 6x6 puzzle under 10 min", // [17]
    "Finish a 6x6 puzzle under 8 min",
    "Finish a 6x6 puzzle under 5 min",
    "Finish a 6x6 puzzle under 4 min",
    
    "Finish a 6x6 puzzle within 600 moves", // [21]
    "Finish a 6x6 puzzle within 450 moves",
    "Finish a 6x6 puzzle within 390 moves"
]

func getEmptyAchievementsString() -> String {
    return emptyAchievements
}

func getAchievements(withMoves moves: Int, withTime secondsElapsed: Int, withBoardSideLenght boardLenght: Int, withCurrentAchievements current: String) -> String {
    
    // cast string into array of characters
    var currentArray = Array(current)
    
    switch boardLenght {
    case 4:
        currentArray[0] = "1"

        currentArray[3] = (secondsElapsed <= 60*10) ? "1" : currentArray[3]
        currentArray[4] = (secondsElapsed <= 60*5) ? "1" : currentArray[4]
        currentArray[5] = (secondsElapsed <= 60*2) ? "1" : currentArray[5]
        currentArray[6] = (secondsElapsed <= 60) ? "1" : currentArray[6]
        
        currentArray[7] = (moves <= 300) ? "1" : currentArray[7]
        currentArray[8] = (moves <= 200) ? "1" : currentArray[8]
        currentArray[9] = (moves <= 100) ? "1" : currentArray[9]
    case 5:
        currentArray[1] = "1"
        
        currentArray[10] = (secondsElapsed <= 60*10) ? "1" : currentArray[10]
        currentArray[11] = (secondsElapsed <= 60*5) ? "1" : currentArray[11]
        currentArray[12] = (secondsElapsed <= 60*2+30) ? "1" : currentArray[12]
        currentArray[13] = (secondsElapsed <= 60*2) ? "1" : currentArray[13]
        
        currentArray[14] = (moves <= 400) ? "1" : currentArray[14]
        currentArray[15] = (moves <= 300) ? "1" : currentArray[15]
        currentArray[16] = (moves <= 275) ? "1" : currentArray[16]
    case 6:
        currentArray[2] = "1"
        
        currentArray[17] = (secondsElapsed <= 60*10) ? "1" : currentArray[17]
        currentArray[18] = (secondsElapsed <= 60*8) ? "1" : currentArray[18]
        currentArray[19] = (secondsElapsed <= 60*5) ? "1" : currentArray[19]
        currentArray[20] = (secondsElapsed <= 60*4) ? "1" : currentArray[20]
        
        currentArray[21] = (moves <= 600) ? "1" : currentArray[21]
        currentArray[22] = (moves <= 450) ? "1" : currentArray[22]
        currentArray[23] = (moves <= 390) ? "1" : currentArray[23]
    default: break
    }
    
    return String(currentArray)
}

func getPoints(withMoves moves: Int, withTime secondsElapsed: Int, withBoardSideLenght boardLenght: Int) -> Int {
    let achievements = getAchievements(withMoves: moves, withTime: secondsElapsed, withBoardSideLenght: boardLenght, withCurrentAchievements: emptyAchievements)
    
    var points = 0
    let achievementsArray = Array(achievements)
    for character in achievementsArray {
        if character == "1" {
            points += 50
        }
    }
    return points
}
