//
//  AlarmDetailsTableViewController.swift
//  Alarm
//
//  Created by Thao Doan on 5/14/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmDetailsTableViewController: UITableViewController, AlarmSchedule {
    
    var detail : Alarm? {
        didSet {
           if  isViewLoaded  {
            // alarm will update every time the view is loaded
            updateViews()
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

   
    @IBOutlet weak var isEnable: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alramTextField: UITextField!
    // MARK: - Table view data source

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // when save button click set if there is a alram title, check if the clock is counted correctly. AM/PM
        guard let title = alramTextField.text,
            let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else { return }
        let timeIntervalSinceMidnight = datePicker.date.timeIntervalSince(thisMorningAtMidnight)
        // check if alarm is not nil
        if let alarm = detail {
            // update the alarm if there is already an alarm
            AlarmModelController.shared.update(alarm: alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
            // then user can cancel when time's up or schedule it
            cancelUserNotifications(for: alarm)
            scheduleUserNotifications(for: alarm)
        // else if there is not an alarm. Add new alarm
        } else {
            let alarm = AlarmModelController.shared.addAlarm(fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
             self.detail = alarm
            //show the notifications
            scheduleUserNotifications(for: alarm)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        guard let alarmDetail = detail else  {return}
            AlarmModelController.shared.toggleEnabled(for: alarmDetail)
        if alarmDetail.enabled {
            scheduleUserNotifications(for: alarmDetail)
        } else {
            cancelUserNotifications(for: alarmDetail)
        }
            self.updateViews()
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func updateViews() {
        guard let detail = detail,
            let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight,
            isViewLoaded else {
                isEnable.isHidden = true
                return
        }
        
        datePicker.setDate(Date(timeInterval: detail.fireTimeFromMidnight, since: thisMorningAtMidnight), animated: false)
        alramTextField.text = detail.name
        
        isEnable.isHidden = false
        if detail.enabled {
            isEnable.setTitle("Disable", for: UIControlState())
            isEnable.setTitleColor(.white, for: UIControlState())
            isEnable.backgroundColor = .red
        } else {
            isEnable.setTitle("Enable", for: UIControlState())
            isEnable.setTitleColor(.blue, for: UIControlState())
            isEnable.backgroundColor = .gray
        }
        
        self.title = detail.name
    }
    
}

