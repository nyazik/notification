//
//  NotificationViewModel.swift
//  optimeSecond
//
//  Created by Nyazik Byashimova on 22.09.2022.
//

import UIKit

enum Sections: Int, CaseIterable {
    case allOrMessageRequestSegment, today, yesterday
    
}


class NotificationViewModel {
    var models2: [Model]?
    var models: [Model]?
    var notificationModel : [NotificationModel]?
    var timer: Timer?
    var refreshTable: ((Bool) -> ())?
}


//MARK: - timer
extension NotificationViewModel {
    
    func appendElemens() {

        let model1 = Model(img: UIImage(named: "a")! , name: "a", messageType : "message request", read: false)
        let model2 = Model(img: UIImage(named: "b")!, name: "b", messageType : "another", read: true)
        let model3 = Model(img: UIImage(named: "c")!, name: "c", messageType : "another", read: false)
        let model4 = Model(img: UIImage(named: "d")!, name: "d", messageType : "message request", read: true)
        
        let model5 = Model(img: UIImage(named: "a")! , name: "a", messageType : "another", read: false)
        let model6 = Model(img: UIImage(named: "b")!, name: "b", messageType : "message request", read: true)
        let model7 = Model(img: UIImage(named: "c")!, name: "c", messageType : "message request", read: false)
        let model8 = Model(img: UIImage(named: "d")!, name: "d", messageType : "another", read: true)
        
        models = [model1, model2, model3, model4]
        models2 = [model5, model6, model7, model8]
        notificationModel = [NotificationModel(day: "td", model: models ?? []),NotificationModel(day: "yesterday", model: models2 ?? []) ]
    }
    
    func startTimer(completeon: () -> ()) {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        completeon()
    }
    
    @objc func fireTimer() {
        print("Timer fired!")
        runLogic()
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    private func runLogic() {
        
        appendRandomElement()
        
        refreshTable?(true)
    }
    
    private func getRandomElementWithin2() -> Int {
        return Int.random(in: 0...1)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func appendRandomElement() {
        let messageType  = ["another", "message request"]
        let randomElenet = getRandomElementWithin2()
        let randomName = randomString(length: 5)
        let randomBool = Bool.random()

        let model5 = Model(img: UIImage(named: "a")! , name: randomName, messageType : messageType[randomElenet], read: randomBool)
        
        
        if randomElenet == 0 {
            self.models?.append(model5)
            notificationModel?[randomElenet] = NotificationModel(day: "td", model: models ?? [])
        } else {
            self.models2?.append(model5)
            notificationModel?[randomElenet] = NotificationModel(day: "yesterday", model: models2 ?? [])
        }
    }

    
}

//MARK: - uitableView
extension NotificationViewModel {
    func numberOfRawInSection(section: Int) -> Int {
        switch section {
        case Sections.allOrMessageRequestSegment.rawValue :
            return 1
        case Sections.today.rawValue :
            let today = notificationModel?.filter { $0.day == "td" }
            return today?.first?.model.count ?? 0
        case Sections.yesterday.rawValue:
            let yesterday = notificationModel?.filter { $0.day == "yesterday" }
            return yesterday?.first?.model.count ?? 0
        default:
            return 0
        }
    }
    
    func titleForHeaderInSection(section: Int) -> String {
        switch section {
        case Sections.allOrMessageRequestSegment.rawValue :
            return ""
        case Sections.today.rawValue :
            if notificationModel?.filter({ $0.day == "td" }).first?.model.count ?? 0 > 0 {
                return "Today"
            } else {
                return ""
            }
            
        case Sections.yesterday.rawValue:
            return "Yesterday"
        default :
            return "no"
        }
    }
    
    
    func commitEditingStyle (indexPathSection : Int, indexPath : IndexPath, completeon : () -> ()) {
        if indexPathSection == Sections.today.rawValue {
            if ((notificationModel?.filter({ $0.day == "td" }).first?.model.remove(at: indexPath.row)) != nil) {
                completeon()
            }
        } else if indexPathSection == Sections.yesterday.rawValue {
            if ((notificationModel?.filter({ $0.day == "yesterday" }).first?.model.remove(at: indexPath.row)) != nil) {
                completeon()
            }
        }
    }
    
    func didSelectRowAt(indexPathSection : Int, indexPath: IndexPath, completeon : () -> ()) {
        if indexPathSection == Sections.today.rawValue {
            if notificationModel?.filter({ $0.day == "td" }).first?.model[indexPath.row].read  == true {
                notificationModel?.filter({ $0.day == "td" }).first?.model[indexPath.row].read = false
                completeon()
            } else {
                notificationModel?.filter({ $0.day == "td" }).first?.model[indexPath.row].read = true
                completeon()
            }
        } else if indexPathSection == Sections.yesterday.rawValue {
            if notificationModel?.filter({ $0.day == "yesterday" }).first?.model[indexPath.row].read  == true {
                notificationModel?.filter({ $0.day == "yesterday" }).first?.model[indexPath.row].read = false
                completeon()
            } else {
                notificationModel?.filter({ $0.day == "yesterday" }).first?.model[indexPath.row].read = true
                completeon()
            }
        }
    }
    

    func cellForRowAt(indexPath: IndexPath) -> [NotificationModel]? {
        var model: [NotificationModel]?
        if indexPath.section == Sections.today.rawValue {
            model = notificationModel?.filter { $0.day == "td" }
        } else if indexPath.section == Sections.yesterday.rawValue {
            model = notificationModel?.filter { $0.day == "yesterday" }
        }
        return model
    }
    
}
