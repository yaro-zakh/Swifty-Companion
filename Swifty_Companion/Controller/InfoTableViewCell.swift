//
//  customTableViewCell.swift
//  Swifty_Companion
//
//  Created by Yaroslav Zakharchuk on 3/15/18.
//  Copyright © 2018 Yaroslav Zakharchuk. All rights reserved.
//

import UIKit


class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var intraProfileImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var correctionPointLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 3)
        progressView.progressImage = #imageLiteral(resourceName: "progressBarImage")
    }
    
    func setStudentLabels(for studentInfo: StudentStruct) {

        displayNameLabel.text = "  " + studentInfo.displayname
        loginLabel.text = studentInfo.login
        phoneNumberLabel.text = studentInfo.phone
        locationLabel.text = studentInfo.location
        walletLabel.text = "Wallet : " + String(studentInfo.wallet) + " ₳"
        correctionPointLabel.text = "Correction : " + String(studentInfo.correction_point)
        yearLabel.text = "Year : " + String(studentInfo.pool_year)
        levelLabel.text = "Level : " + String(studentInfo.level) + "%"
        gradeLabel.text = "Grade : " + studentInfo.grade
        emailLabel.text = studentInfo.email
        progressView.progress = studentInfo.level.truncatingRemainder(dividingBy: 1)
        
        if let imageAdrs = studentInfo.imageUrl {
            let URL_IMAGE = URL(string: imageAdrs)
            let session = URLSession(configuration: .default)
            let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { (data, response, error) in
                if let e = error {
                    print("Error Occurred: \(e)")
                } else {
                    if (response as? HTTPURLResponse) != nil {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                self.intraProfileImage.image = image
                                self.intraProfileImage.layer.masksToBounds = false
                                self.intraProfileImage.layer.borderWidth = 2
                                self.intraProfileImage.layer.borderColor = UIColor.white.cgColor
                                self.intraProfileImage.layer.cornerRadius = self.intraProfileImage.frame.size.width / 2
                                self.intraProfileImage.clipsToBounds = true
                            }
                        } else {
                            print("Image file is currupted")
                        }
                    } else {
                        print("No response from server")
                    }
                }
            }
            getImageFromUrl.resume()
        }
    }
    
}


