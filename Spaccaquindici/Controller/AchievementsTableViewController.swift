//
//  AchievementsTableViewController.swift
//  Spaccaquindici
//
//  Created by Giovi on 17/08/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit
import CoreData

class AchievementsTableViewController: UITableViewController {

    // Database variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    var results = [Any]()
    var selectedUsername = ""
    var selectedUserAchievements = ""
    
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
        // retrieve from db all the users
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(value: true)
        
        request.returnsObjectsAsFaults = false
        
        do {
            self.results = try context.fetch(request)
        } catch {
            print("error while fetching usernames")
        }
        
        return results.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select a Username"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let username = self.results as! [NSManagedObject]
        cell.textLabel?.text = "\(username[indexPath.row].value(forKey: "name") as! String)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usernames = self.results as! [NSManagedObject]
        self.selectedUsername = usernames[indexPath.row].value(forKey: "name") as! String
        self.selectedUserAchievements = usernames[indexPath.row].value(forKey: "achievements") as! String
        self.performSegue(withIdentifier: "Show User Achievements", sender: self)
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show User Achievements" {
            if let userAchievementsVC = segue.destination as? UserAchievements {
                userAchievementsVC.username = self.selectedUsername
                userAchievementsVC.achievements = self.selectedUserAchievements
            }
        }
    }

}
