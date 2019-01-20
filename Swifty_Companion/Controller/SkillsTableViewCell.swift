//
//  skillsTableViewCell.swift
//  Swifty_Companion
//
//  Created by Yaroslav Zakharchuk on 3/15/18.
//  Copyright © 2018 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var skillNameLabel: UILabel!
    @IBOutlet weak var skillProgressLabel: UIProgressView!
    
    func setStudentSkills(skill: SkillsStruct) {
        if let level = skill.level, let name = skill.name {
            skillProgressLabel.progress = level.truncatingRemainder(dividingBy: 1)
            skillNameLabel.text = name + " " + String(level) + "%"
        }
    }
}
