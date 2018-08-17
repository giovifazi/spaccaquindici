//
//  AchievementsTableViewController.swift
//  Spaccaquindici
//
//  Created by Giovi on 17/08/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit
import CoreData

class UserAchievements: UITableViewController {
    
    // Database variables
    var achievements : String? = nil
    var username : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return username!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let achievArray = Array(achievements!)
        
        if achievArray[indexPath.row] == "1" {
            cell.textLabel?.text = "Done: \(achievementsDescription[indexPath.row])"
            cell.textLabel?.textColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        } else {
            cell.textLabel?.text = "To Do: \(achievementsDescription[indexPath.row])"
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        
        return cell
    }
    
}
