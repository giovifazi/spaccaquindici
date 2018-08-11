//
//  GameSetupViewController.swift
//  Spaccaquindici
//
//  Created by Giovi on 31/05/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit

class GameSetupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var boardLayoutSegmented: UISegmentedControl!
    
    let images = [#imageLiteral(resourceName: "fedora"), #imageLiteral(resourceName: "unibo"), #imageLiteral(resourceName: "smile") ]
    private var boardSize = 4
    @IBOutlet weak var imageUIPicker: UIPickerView!
    var rotationAngle: CGFloat!
    let width:CGFloat = 190
    let height:CGFloat = 190
    
    // returns the number of columns of the picker
    // each column is a new picker eg: return 2 -> |pick|pick|
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of elements to choose from, within a single component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return height + 10
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return width + 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let imageToChoose = UIImageView()
        imageToChoose.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageToChoose.image = images[row]
        
        // rotate the image
        imageToChoose.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        view.addSubview(imageToChoose)
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Play button rounded corner
        playButton.layer.cornerRadius = 10
        
        imageUIPicker.delegate = self
        imageUIPicker.dataSource = self
        
        // rotate the pickerview, then resize the frame
        // with the old coordinates
        rotationAngle = -90 * (.pi/180)
        let oldY = imageUIPicker.frame.origin.y
        imageUIPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        imageUIPicker.frame = CGRect(x: -50, y: oldY, width: view.frame.width + 100, height: 216)

        self.view.addSubview(imageUIPicker)
    }

    @IBAction func addImage(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Play Game" {
            if let gvcontroller = segue.destination as? GameViewController {
                
                // Pass the size to gameController
                switch boardLayoutSegmented.selectedSegmentIndex {
                    case 0: gvcontroller.boardSideLength = 4
                    case 1: gvcontroller.boardSideLength = 5
                    case 2: gvcontroller.boardSideLength = 6
                    default:    gvcontroller.boardSideLength = 4
                }
                
                // Pass the image to gameController
                gvcontroller.gameImage = images[imageUIPicker.selectedRow(inComponent: 0)]
            }
        }
    }
 

}
