//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Thao Doan on 5/14/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate : class {
   func alarmValueChange(cell: UITableViewCell)
}
class SwitchTableViewCell: UITableViewCell {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
   weak var delegate: SwitchTableViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var switchView: UISwitch!


    func updateViews() {
        guard let alarm = alarm else {return }
            
            switchView.isOn = alarm.enabled
            nameLabel.text = alarm.name
            detailLabel.text = alarm.fireTimeAsString
    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.alarmValueChange(cell: self)
        
    }
}
