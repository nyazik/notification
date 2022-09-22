//
//  NotificationViewModel.swift
//  optimeSecond
//
//  Created by Nyazik Byashimova on 22.09.2022.
//

import UIKit

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
