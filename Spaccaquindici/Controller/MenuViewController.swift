//
//  MenuViewController.swift
//  Spaccaquindici
//
//  Created by Giovi on 19/05/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {


    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var LeaderboardButton: UIButton!
    @IBOutlet weak var AchievementsButton: UIButton!
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
 
    override func viewDidLoad() {
        PlayButton.layer.cornerRadius = 5
        LeaderboardButton.layer.cornerRadius = 5
        AchievementsButton.layer.cornerRadius = 5
    }

}
