//
//  NotificationModel.swift
//  optimeSecond
//
//  Created by Nyazik Byashimova on 19.09.2022.
//

import Foundation
import UIKit

class NotificationModel {
    let day : String
    var model : [Model]
    init(day : String, model : [Model]) {
        self.day = day
        self.model = model
    }
}

class Model {
    let img : UIImage
    let name : String
    let messageType : String
    var read : Bool
    init(img: UIImage, name :String, messageType : String, read : Bool) {
        self.img = img
        self.name = name
        self.messageType = messageType
        self.read = read
    }
}
