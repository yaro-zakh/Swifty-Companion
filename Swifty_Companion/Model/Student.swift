//
//  File.swift
//  Swifty_Companion
//
//  Created by Yaroslav Zakharchuk on 3/15/18.
//  Copyright © 2018 Yaroslav Zakharchuk. All rights reserved.
//

import Foundation

struct StudentStruct {
    
    var login = "none"
    var displayname = "none"
    var email = "no email"
    var phone = "no phone"
    var correction_point = 0
    var location = "Unaviable"
    var wallet = 0
    var pool_year = 2016
    var grade = "Novice"
    var level : Float = 0.0
    var imageUrl: String?
    
    var skills = [SkillsStruct]()
    var projects = [MarksStruct]() // no label
}

struct SkillsStruct {
    var name: String?
    var level: Float?
}

struct MarksStruct {
    var finalMark: Int?
    var name: String?
    var validated: Bool?
}
