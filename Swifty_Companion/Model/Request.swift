//
//  Request.swift
//  Swifty_Companion
//
//  Created by Yaroslav Zakharchuk on 3/15/18.
//  Copyright © 2018 Yaroslav Zakharchuk. All rights reserved.
//

import Foundation

class Request {
    var UID: String
    var SECRET: String
    var token: String?
    var student = StudentStruct()
    
    init(UID: String, SECRET: String) {
        self.UID = UID
        self.SECRET = SECRET
    }
    
    public func requestForToken() {
        let BEARER = ((UID + ":" + SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        
        let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(SECRET)".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: d, options: []) as? NSDictionary {
                        if let t = dic["access_token"] as? String {
                            self.token = t
                        }
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }
    
    public func signIn(studentName: String, completion: @escaping (NSDictionary?, Error?) -> Void) {
        let req = "https://api.intra.42.fr/v2/users/" + studentName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! + "?access_token=" + self.token!
        let url = URL(string: req)
        let request = URLRequest(url: url! as URL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: d, options: []) as? NSDictionary {
                        completion(dic, nil)
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
            completion(nil, error)
        }
        task.resume()
    }
    
    
    public func setStudent(dic: NSDictionary) {
        if let name = dic["displayname"] as? String {
            self.student.displayname = name
        }
        if let email = dic["email"] as? String {
            self.student.email = email
        }
        if let phone = dic["phone"] as? String {
            self.student.phone = phone
        }
        if let image = dic["image_url"] as? String {
            self.student.imageUrl = image
        }
        if let correction_point = dic["correction_point"] as? Int {
            self.student.correction_point = correction_point
        }
        if let location = dic["location"] as? String {
            self.student.location = location
        }
        if let wallet = dic["wallet"] as? Int {
            self.student.wallet = wallet
        }
        if let pool_year = dic["pool_year"] as? Int {
            self.student.pool_year = pool_year
        }
        if let dictionary = dic["cursus_users"] as? [NSDictionary] {
            for cursus in dictionary {
                if let a = cursus.value(forKey: "cursus_id") as? Int {
                    if a == 1 {
                        if let g = cursus.value(forKey: "grade") as? String {
                            self.student.grade = g
                        }
                        if let l = cursus.value(forKey: "level") as? Float {
                            self.student.level = l
                        }
                        if let skillDictionary = cursus.value(forKey: "skills") as? [NSDictionary] {
                            for skill in skillDictionary {
                                self.student.skills.append(SkillsStruct(name: skill.value(forKey: "name") as? String, level: skill.value(forKey: "level") as? Float))
                            }
                        }
                    }
                }
            }
        }
        if let projects = dic["projects_users"] as? [NSDictionary] {
            for project in projects {
                if let a = project.value(forKey: "cursus_ids") as? [Int] {
                    if a[0] == 1 {
                        if let mark = project.value(forKey: "final_mark") as? Int,
                            let valid = project.value(forKey: "validated?") as? Bool,
                            let pro = project.value(forKey: "project") as? [String: Any?] {
                            self.student.projects.append(MarksStruct(finalMark: mark, name: pro["slug"] as? String, validated: valid))
                        }
                    }
                }
            }
        }
    }
}


