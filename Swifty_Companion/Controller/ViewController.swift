//
//  ViewController.swift
//  Swifty_Companion
//
//  Created by Yaroslav Zakharchuk on 3/15/18.
//  Copyright © 2018 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var studentName = String()
    var request = Request(UID: "c67b8eb4125ad66a1708bf4e3d099f9f646c0c35739449f4f4ae5d9be487f69d", SECRET: "e0ccb26cfad9f67f90de0d6058e2120d2101d3b5b347f341b97f54c59c274254")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.delegate = self
        request.requestForToken()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        errorLabel.isHidden = true
        
        usernameField.alpha = 0.8
        usernameField.layer.cornerRadius = 5
        usernameField.layer.borderWidth = 1.5
        usernameField.layer.borderColor = UIColor.white.cgColor
        
        searchButton.backgroundColor = .clear
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderWidth = 1.5
        searchButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    func emtyField() {
        errorLabel.alpha = 0.8
        errorLabel.backgroundColor = UIColor(red:0.92, green:0.89, blue:0.61, alpha:1.0)
        errorLabel.textColor = UIColor(red:0.42, green:0.31, blue:0.50, alpha:1.0)
        errorLabel.text = "User name field is emty!"
        errorLabel.isHidden = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func checkName() {
        
        DispatchQueue.main.async {
            self.errorLabel.alpha = 0.7
            self.errorLabel.backgroundColor = UIColor(red:1.00, green:0.40, blue:0.40, alpha:1.0)
            self.errorLabel.textColor = UIColor(red:0.91, green:0.89, blue:0.92, alpha:1.0)
            self.errorLabel.text = "Wrong user name!"
            self.errorLabel.isHidden = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    @IBAction func touchSearch(_ sender: UIButton) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        errorLabel.isHidden = true
        if let name = usernameField.text {
            studentName = name.split(separator: " ").joined()
            if studentName == "" {
                emtyField()
            } else {
                self.request.student = StudentStruct()
                self.request.student.login = studentName
            }
        }
        
        
        if studentName != "" {
            self.request.signIn(studentName: studentName, completion: { (dictionary, error) in
                if let err = error {
                    print(err)
                }
                if let dic = dictionary {
                    if (dic.count > 0) {
                        self.request.setStudent(dic: dic)
                        DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.performSegue(withIdentifier: "firstSegue", sender: self)
                            self.usernameField.text = ""
                        }
                    } else {
                        self.checkName()
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dectinationView: MyTableViewController = segue.destination as! MyTableViewController
        dectinationView.studentInfo = self.request.student
    }
    
    // MARK: keyboard settings
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -50
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        return(true)
    }
}

