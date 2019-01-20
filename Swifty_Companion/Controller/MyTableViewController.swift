//
//  MyTableViewController.swift
//  Swifty_Companion
//
//  Created by Yaroslav Zakharchuk on 3/15/18.
//  Copyright © 2018 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

fileprivate enum SectionIdentifiers {
    case profile
    case skills
    case projects
}

class MyTableViewController: UITableViewController {
    
    var studentInfo: StudentStruct!
    fileprivate var sections: [SectionIdentifiers] = [.profile, .skills, .projects]
    private let sectionsImages: [UIImage] = [#imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "skills"), #imageLiteral(resourceName: "project")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSections()
    }
    
    private func configureSections() {
        setupSkills()
        setupProjects()
        tableView.reloadData()
    }
    
    private func setupSkills() {
        if studentInfo.skills.isEmpty {
            if let index = sections.index(of: .skills) {
                sections.remove(at: index)
            }
        }
    }
    
    private func setupProjects() {
        if studentInfo.projects.isEmpty {
            if let index = sections.index(of: .projects) {
                sections.remove(at: index)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        switch currentSection {
        case .profile:
            return 1
        case .skills:
                return studentInfo.skills.count
        case .projects:
                return studentInfo.projects.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.78, green:0.58, blue:0.29, alpha:1.0)
        
        let image = UIImageView(image: sectionsImages[section])
        image.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(image)
        
        let label = UILabel()
        label.text = String(describing: sections[section])
        label.frame = CGRect(x: 45, y: 5, width: 100, height: 35)
        view.addSubview(label)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section]
        switch currentSection {
        case .profile:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? InfoTableViewCell {
                    cell.setStudentLabels(for: studentInfo)
                return cell
            }
        case .skills:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SkillsCell", for: indexPath) as? SkillsTableViewCell {
                    cell.setStudentSkills(skill: studentInfo.skills[indexPath.row])
                return cell
            }
        case .projects:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectTableViewCell {
                    cell.setStudentProject(project: studentInfo.projects[indexPath.row])
                    if let valid = studentInfo.projects[indexPath.row].validated {
                        if valid == true {
                            cell.contentView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
                        } else {
                            cell.contentView.backgroundColor = UIColor(red:0.20, green:0.35, blue:0.41, alpha:1.0)
                        }
                    }
                return cell
            }
        }
        return UITableViewCell()
    }
}

