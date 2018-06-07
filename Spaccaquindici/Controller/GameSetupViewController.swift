//
//  GameSetupViewController.swift
//  Spaccaquindici
//
//  Created by Giovi on 31/05/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit

class GameSetupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let images = [#imageLiteral(resourceName: "fedora"), #imageLiteral(resourceName: "unibo"), #imageLiteral(resourceName: "smile") ]
    private var boardSize = 4
    @IBOutlet weak var imageUIPicker: UIPickerView!
    var rotationAngle: CGFloat!
    let width:CGFloat = 100
    let height:CGFloat = 200
    
    // example: 1 => |comp|     2 => |comp1|comp2|
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of elements to choose from, within a single component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let imageToChoose = UIImageView()
        imageToChoose.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageToChoose.image = images[row]
        
        view.addSubview(imageToChoose)
        
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageUIPicker.delegate = self
        imageUIPicker.dataSource = self
        imageUIPicker.layer.borderWidth = 1.5
        
        // picker view rotation
        rotationAngle = -90 * (.pi/180)
        imageUIPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        imageUIPicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        imageUIPicker.center = self.view.center
        self.view.addSubview(imageUIPicker)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Size" {
            if let sizeChosen = (sender as? UIButton)?.currentTitle {
                if let gvcontroller = segue.destination as? GameViewController {
                    
                    // Pass the size to gameController
                    switch sizeChosen {
                        case "4x4": gvcontroller.boardSideLength = 4
                        case "5x5": gvcontroller.boardSideLength = 5
                        case "6x6": gvcontroller.boardSideLength = 6
                        default:    gvcontroller.boardSideLength = 4
                    }
                    
                    // Pass the image to gameController
                    gvcontroller.gameImage = images[imageUIPicker.selectedRow(inComponent: 0)]
                }
            }
        }
    }
 

}
