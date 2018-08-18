//
//  GameViewController.swift
//  Spaccaquindici
//
//  Created by Giovi on 31/05/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit
import CoreData

class GameViewController: UIViewController {

    // Game variables
    var boardSideLength:Int!
    var gameBoard:Board!
    var gameButtons = [UIButton]()
    var gameImage:UIImage!
    
    // Popup variables
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var visualEffectBlur: UIVisualEffectView!
    var blurEffect:UIVisualEffect!
    @IBOutlet weak var scoreLabelPopup: UILabel!
    @IBOutlet weak var shareButtonPopup: UIButton!
    @IBOutlet weak var closeButtonPopup: UIButton!
    @IBOutlet weak var usernameTextfieldPopup: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    // Show image and toggle numbers variables
    var solvedImageView = UIImageView()
    var gameBoardFrame = CGRect()
    var showNumbers = false
    var showImage = false
    
    // Gameplay variables
    let scrambleMoves = 200 //200 is fine for all layouts
    var isScrambling = true
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
    
    func makePopupAppear() -> Void {
        self.view.addSubview(popupView)
        popupView.center = self.view.center
        
        popupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popupView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.view.bringSubview(toFront: self.visualEffectBlur)
            self.view.bringSubview(toFront: self.popupView)
            self.visualEffectBlur.effect = self.blurEffect
            self.popupView.alpha = 1
            self.popupView.transform = CGAffineTransform.identity
        }
        
        scoreLabelPopup.text = (timeElapsed % 60 < 10) ? "\(moves) moves in \(timeElapsed/60):0\(timeElapsed%60)" : "\(moves) moves in \(timeElapsed/60):\(timeElapsed%60)"
        
        shareButtonPopup.layer.cornerRadius = 10
        closeButtonPopup.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Popup View
        blurEffect = visualEffectBlur.effect
        visualEffectBlur.effect = nil
        
        popupView.layer.cornerRadius = 5
        
        // Game View
        let boardRect = calculateBoardBounds()
        gameBoardFrame = boardRect

        
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
                    button.layer.cornerRadius = 17
                    button.layer.masksToBounds = true
                    
                    
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
        isScrambling = false
    }
    
    @IBAction func shareScore(_ sender: UIButton) {

        let stringToShare = "Check out Spaccaquindici and try to beat my score of \(moves) moves and \(timeElapsed/60) minutes \(timeElapsed%60) seconds"
        let activityController = UIActivityViewController(activityItems: [stringToShare], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func closePopup(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.popupView.alpha = 0
            self.visualEffectBlur.effect = nil
        }) {
            (success: Bool) in
                self.popupView.removeFromSuperview()
        }
        
        // Check achievents unlocked if a valid username is entered
        if usernameTextfieldPopup.text != "" {
            
            // check if username already exists in the db
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.predicate = NSPredicate(format: "name = %@", usernameTextfieldPopup.text!)
            
            request.returnsObjectsAsFaults = false
            
            do {
                let result = try context.fetch(request)
                
                // if no user exists with that name, create it
                if result.isEmpty {
                    let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                    let newUser = NSManagedObject(entity: entity!, insertInto: context)
                    
                    // set values for new user entry
                    newUser.setValue(usernameTextfieldPopup.text, forKey: "name")
                    newUser.setValue(getAchievements(withMoves: moves, withTime: timeElapsed, withBoardSideLenght: boardSideLength, withCurrentAchievements: emptyAchievements), forKey: "achievements")
                    
                    if boardSideLength == 4 {
                        newUser.setValue(moves, forKey: "pb4x4moves")
                        newUser.setValue(timeElapsed, forKey: "pb4x4time")
                    } else {
                        newUser.setValue(Int16.max, forKey: "pb4x4moves")
                        newUser.setValue(Int16.max, forKey: "pb4x4time")
                    }
                    
                    if boardSideLength == 5 {
                        newUser.setValue(moves, forKey: "pb5x5moves")
                        newUser.setValue(timeElapsed, forKey: "pb5x5time")
                    } else {
                        newUser.setValue(Int16.max, forKey: "pb5x5moves")
                        newUser.setValue(Int16.max, forKey: "pb5x5time")
                    }

                    if boardSideLength == 6 {
                        newUser.setValue(moves, forKey: "pb6x6moves")
                        newUser.setValue(timeElapsed, forKey: "pb6x6time")
                    } else {
                        newUser.setValue(Int16.max, forKey: "pb6x6moves")
                        newUser.setValue(Int16.max, forKey: "pb6x6time")
                    }

                    newUser.setValue(getPoints(withMoves: moves, withTime: timeElapsed, withBoardSideLenght: boardSideLength), forKey: "score")
                    
                    do {
                        try context.save()
                    } catch {
                        print("failed saving")
                    }
                } else {
                    // if user was already registred on the database

                    let resultArray = result as! [NSManagedObject]
                    let oldUser = resultArray.first
                    
                    // updates achievements string
                    oldUser?.setValue(getAchievements(withMoves: moves, withTime: timeElapsed, withBoardSideLenght: boardSideLength, withCurrentAchievements: oldUser?.value(forKey: "achievements") as! String), forKey: "achievements")
                    
                    // updates score
                    oldUser?.setValue(oldUser?.value(forKey: "score") as! Int + getPoints(withMoves: moves, withTime: timeElapsed, withBoardSideLenght: boardSideLength), forKey: "score")
                    
                    // update personal best's times if needed
                    switch boardSideLength {
                        case 4:
                            if moves < oldUser?.value(forKey: "pb4x4moves") as! Int {
                                oldUser?.setValue(moves, forKey: "pb4x4moves")
                            }
                            
                            if timeElapsed < oldUser?.value(forKey: "pb4x4time") as! Int {
                                oldUser?.setValue(timeElapsed, forKey: "pb4x4time")
                            }
                        case 5:
                            if moves < oldUser?.value(forKey: "pb5x5moves") as! Int {
                                oldUser?.setValue(moves, forKey: "pb5x5moves")
                            }
                            
                            if timeElapsed < oldUser?.value(forKey: "pb5x5time") as! Int {
                                oldUser?.setValue(timeElapsed, forKey: "pb5x5time")
                            }
                        case 6:
                            if moves < oldUser?.value(forKey: "pb6x6moves") as! Int {
                                oldUser?.setValue(moves, forKey: "pb6x6moves")
                            }
                            
                            if timeElapsed < oldUser?.value(forKey: "pb6x6time") as! Int {
                                oldUser?.setValue(timeElapsed, forKey: "pb6x6time")
                            }
                    case .none:
                        break
                    case .some(_):
                        break
                    }
                    
                    for data in result as! [NSManagedObject] {
                        print(data.value(forKey: "name") as! String)
                        print(data.value(forKey: "achievements") as! String)
                        print(data.value(forKey: "score") as! Int)
                        print(data.value(forKey: "pb4x4moves") as! Int)
                        print(data.value(forKey: "pb4x4time") as! Int)
                    }
                }
            } catch {
                print("error while fetching username")
            }
        }
        
        _ = navigationController?.popViewController(animated: true)
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
    
    @IBAction func showImage(_ sender: UIBarButtonItem) {
        
        if showImage == false {
            showImage = true
            
            // make all buttons transparent
            for button in gameButtons {
                button.alpha = 0
            }
            
            var adjustedFrame = gameBoardFrame
            adjustedFrame.origin.y += 22.5
            
            // then print the solved image
            solvedImageView = UIImageView(frame: adjustedFrame)
            solvedImageView.image = gameImage
            self.view.addSubview(solvedImageView)
        } else {
            showImage = false
            
            // restore buttons transparency
            for button in gameButtons {
                button.alpha = 1.0
            }
            
            // delete solved imageview from hierarcy
            solvedImageView.removeFromSuperview()
        }
    }
    
    @IBAction func toggleNumbers(_ sender: UIBarButtonItem) {
        
        if showNumbers == false {
            showNumbers = true
            for button in gameButtons {
                button.titleLabel?.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                button.titleLabel?.layer.shadowOpacity = 1.0
                button.titleLabel?.layer.shadowRadius = 5
                button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
                
                button.text("\(button.tag+1)")
            }
        } else {
            showNumbers = false
            for button in gameButtons {
                button.text("")
            }
        }

    }
    
    @objc func buttonDidTouch(_ sender: UIButton) {
        // used to prevent multiple touches on same button
        sender.isUserInteractionEnabled = false
        
        // move buttons in the view
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
                
                // activate move counter and time if the player makes first move
                if !isScrambling {

                    moves += 1

                    if timer == nil {
                        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.increaseElapsedTime), userInfo: nil, repeats: true)
                    }
                }
                
                // if the puzzle is solved stop playing
                if gameBoard.checkIfSolved() {
                    
                    // stop buttons from moving
                    for button in gameButtons {
                        button.removeTarget(self, action: #selector(GameViewController.buttonDidTouch(_:)), for: .touchUpInside)
                    }
                    
                    // stop timer
                    timer.invalidate()
                    
                    makePopupAppear()
                }
            }
        }
        
        // release lock mechanism to prevent fast multitap
        sender.isUserInteractionEnabled = true
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
