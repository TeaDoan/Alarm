//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Thao Doan on 5/14/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit
import UserNotifications
class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate,AlarmSchedule{
    // conform the protocol from the table cell controller
    func alarmValueChange(cell: UITableViewCell) {
        // check if there is index path at the cell
        guard let index = tableView.indexPath(for: cell) else {return}
        // use the index to find the corect alram
        let alarm = AlarmModelController.shared.alarms[index.row]
        // check the toggleEnabled function
        AlarmModelController.shared.toggleEnabled(for: alarm)
        //  check if alarm is enabled if it's true
        if alarm.enabled {
            
            scheduleUserNotifications(for: alarm)
        } else {
            
            cancelUserNotifications(for: alarm)
        }
        // reload the row at the right index path that we checked earlier
       tableView.reloadRows(at: [index], with: .automatic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmModelController.shared.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell
        let alarm = AlarmModelController.shared.alarms[indexPath.row]
        cell?.alarm = alarm
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmModelController.shared.alarms[indexPath.row]
            AlarmModelController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToDetail" {
            guard let destinationVc = segue.destination as? AlarmDetailsTableViewController,
                let index = tableView.indexPathForSelectedRow else {return}
                let alarmToPass = AlarmModelController.shared.alarms[index.row]
                destinationVc.detail = alarmToPass
        }
    }
    

}
