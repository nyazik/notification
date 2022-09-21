//
//  ViewController.swift
//  optimeSecond
//
//  Created by Nyazik Byashimova on 17.09.2022.
//

import UIKit

enum Sections: Int, CaseIterable {
    case allOrMessageRequestSegment, today, yesterday
    
}

class NotificationsViewController: UIViewController {

    @IBOutlet weak var readAllButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var notificationModel : [NotificationModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        readAllButton.title = "Read All"
        
        //register cells
        tableView.register(UINib(nibName: "NotificationTableViewSection", bundle: nil), forCellReuseIdentifier: "notificationCell")
        tableView.register(UINib(nibName: "SegmentCell", bundle: nil), forCellReuseIdentifier: "segmentCell")
        
        appendElemens()
    }
}

//MARK: - appendElemetsToArray
extension NotificationsViewController {
    func appendElemens() {
        let model1 = Model(img: UIImage(named: "a")! , name: "a", messageType : "message request", read: false)
        let model2 = Model(img: UIImage(named: "b")!, name: "b", messageType : "another", read: true)
        let model3 = Model(img: UIImage(named: "c")!, name: "c", messageType : "another", read: false)
        let model4 = Model(img: UIImage(named: "d")!, name: "d", messageType : "message request", read: true)
        
        let model5 = Model(img: UIImage(named: "a")! , name: "a", messageType : "another", read: false)
        let model6 = Model(img: UIImage(named: "b")!, name: "b", messageType : "message request", read: true)
        let model7 = Model(img: UIImage(named: "c")!, name: "c", messageType : "message request", read: false)
        let model8 = Model(img: UIImage(named: "d")!, name: "d", messageType : "another", read: true)
        
        let models = [model1, model2, model3, model4]
        let models2 = [model5, model6, model7, model8]
        notificationModel = [NotificationModel(day: "td", model: models),NotificationModel(day: "yesterday", model: models2) ]
    }
}

//MARK: - UITableViewDelegate
extension NotificationsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if indexPath.section == Sections.today.rawValue {
            if notificationModel?.filter({ $0.day == "td" }).first?.model[indexPath.row].read  == true {
                notificationModel?.filter({ $0.day == "td" }).first?.model[indexPath.row].read = false
                self.tableView.reloadData()
            } else {
                notificationModel?.filter({ $0.day == "td" }).first?.model[indexPath.row].read = true
                self.tableView.reloadData()
            }
        } else if indexPath.section == Sections.yesterday.rawValue {
            if notificationModel?.filter({ $0.day == "yesterday" }).first?.model[indexPath.row].read  == true {
                notificationModel?.filter({ $0.day == "yesterday" }).first?.model[indexPath.row].read = false
                self.tableView.reloadData()
            } else {
                notificationModel?.filter({ $0.day == "yesterday" }).first?.model[indexPath.row].read = true
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension NotificationsViewController : UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Sections.allOrMessageRequestSegment.rawValue :
            return ""
        case Sections.today.rawValue :
            return "Today"
        case Sections.yesterday.rawValue:
            return "Yesterday"
        default :
            return "no"
        }
    
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == Sections.today.rawValue {
            guard let cell  = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? NotificationTableViewSection else {
                fatalError("cell not found")
            }
            cell.selectionStyle = .none
            let today = notificationModel?.filter { $0.day == "td" }
            cell.nameLabel.text = "today"
            cell.nameLabel.text = today?.first?.model[indexPath.row].name
            cell.messageType.text = today?.first?.model[indexPath.row].messageType
            cell.userImageView.image = today?.first?.model[indexPath.row].img
            cell.readView.isHidden = today?.first?.model[indexPath.row].read ?? false
            
            return cell
        } else if indexPath.section == Sections.yesterday.rawValue {
            guard let cell  = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? NotificationTableViewSection else {
                fatalError("cell not found")
            }
            cell.selectionStyle = .none
            let yesterday = notificationModel?.filter { $0.day == "yesterday" }
            cell.nameLabel.text = yesterday?.first?.model[indexPath.row].name
            cell.userImageView.image = yesterday?.first?.model[indexPath.row].img
            cell.messageType.text = yesterday?.first?.model[indexPath.row].messageType
            cell.readView.isHidden = yesterday?.first?.model[indexPath.row].read ?? false

            return cell
        } else {
            guard let cell  = tableView.dequeueReusableCell(withIdentifier: "segmentCell") as? SegmentCell else {
                fatalError("cell not found")
            }
            cell.selectedSegment =  { [weak self] value in
                if value == 1 {
                    guard let notificationModel = self?.notificationModel else { return }
                    for i in 0..<notificationModel.count  {
                        notificationModel[i].model = notificationModel[i].model.filter { $0.messageType == "message request" }
                    }
                    self?.tableView.reloadData()
                } else {
                    self?.appendElemens()
                    self?.tableView.reloadData()
                }
            }
            cell.selectionStyle = .none
            return cell
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

//MARK: - Actions
extension NotificationsViewController {
    
    @IBAction func readAllButtonTapped(_ sender: Any) {
        if readAllButton.title == "Read All" {
            readAllButton.title = "Unread All"
            guard let notificationModel = self.notificationModel else { return }
            for i in 0..<notificationModel.count  {
                for j in 0..<notificationModel[i].model.count {
                    if notificationModel[i].model[j].read == false {
                        notificationModel[i].model[j].read = true
                    }
                }
            }
        } else {
            readAllButton.title = "Read All"
            guard let notificationModel = self.notificationModel else { return }
            for i in 0..<notificationModel.count  {
                for j in 0..<notificationModel[i].model.count {
                    notificationModel[i].model[j].read = false
                }
            }
        }
        self.tableView.reloadData()
    }
    
}

