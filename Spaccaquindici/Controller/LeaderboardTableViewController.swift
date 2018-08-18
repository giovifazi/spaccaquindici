//
//  LeaderboardTableViewController.swift
//  Spaccaquindici
//
//  Created by Giovi on 17/08/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit
import CoreData

class LeaderboardTableViewController: UITableViewController {

    // Database variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    var results = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Top 5 scores"
        case 1:
            return "Best time on 4x4 puzzle"
        case 2:
            return "Best time on 5x5 puzzle"
        case 3:
            return "Best time on 6x6 puzzle"
        default:
            return "Section"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        switch indexPath.section {
        case 0:
            // top 5 scores
            request.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
            request.fetchLimit = 5
        case 1:
            // best time 4x4
            request.sortDescriptors = [NSSortDescriptor(key: "pb4x4time", ascending: true)]
            request.fetchLimit = 1
        case 2:
            // best time 5x5
            request.sortDescriptors = [NSSortDescriptor(key: "pb5x5time", ascending: true)]
            request.fetchLimit = 1
        case 3:
            // best time 6x6
            request.sortDescriptors = [NSSortDescriptor(key: "pb6x6time", ascending: true)]
            request.fetchLimit = 1
        default:
            request.predicate = NSPredicate(value: true)
        }
        
        request.returnsObjectsAsFaults = false
        
        do {
            self.results = try context.fetch(request)
        } catch {
            print("error while fetching usernames")
        }

        switch indexPath.section {
        case 0:
            // top 5 scores
            if self.results.indices.contains(indexPath.row) {
                let user = self.results[indexPath.row] as! NSManagedObject
                cell.detailTextLabel?.text = "\(user.value(forKey: "score") ?? "0")"
                cell.textLabel?.text = "\(user.value(forKey: "name") ?? "0")"
            }
        case 1:
            //best time 4x4
            if self.results.indices.contains(indexPath.row) {
                let user = self.results[indexPath.row] as! NSManagedObject
                
                let minutes = user.value(forKey: "pb4x4time") as! Int16 / 60
                let seconds = user.value(forKey: "pb4x4time") as! Int16 % 60
                cell.detailTextLabel?.text = "\(minutes):\(seconds)"
                cell.textLabel?.text = "\(user.value(forKey: "name") ?? "0")"
            }
        case 2:
            //best time 5x5
            if self.results.indices.contains(indexPath.row) {
                let user = self.results[indexPath.row] as! NSManagedObject
                
                let minutes = user.value(forKey: "pb5x5time") as! Int16 / 60
                let seconds = user.value(forKey: "pb5x5time") as! Int16 % 60
                cell.detailTextLabel?.text = "\(minutes):\(seconds)"
                cell.textLabel?.text = "\(user.value(forKey: "name") ?? "0")"
            }
        case 3:
            //best time 6x6
            if self.results.indices.contains(indexPath.row) {
                let user = self.results[indexPath.row] as! NSManagedObject
                
                let minutes = user.value(forKey: "pb6x6time") as! Int16 / 60
                let seconds = user.value(forKey: "pb6x6time") as! Int16 % 60
                print(user.value(forKey: "pb6x6time") as! Int16)
                cell.detailTextLabel?.text = "\(minutes):\(seconds)"
                cell.textLabel?.text = "\(user.value(forKey: "name") ?? "0")"

            }
        default:
            cell.textLabel?.text = "\(indexPath.row):\(indexPath.section)"
        }

        return cell
    }

}
