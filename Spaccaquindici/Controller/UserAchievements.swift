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
    
    @IBAction func deleteUserFromDatabase(_ sender: UIBarButtonItem) {
        // create the alert
        let alert = UIAlertController(title: "Warning", message: "Would you like to delete this user?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            // Create Fetch Request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.username!)
            
            do {
                let results = try context.fetch(fetchRequest) as? [NSManagedObject]
                
                if (results?.count)! > 0 {
                    context.delete(results![0])
                }
            } catch {
            }
            
            do {
                try context.save()
            } catch {
                print("failed saving")
            }
            
            _ = self.navigationController?.popViewController(animated: true)
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
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
