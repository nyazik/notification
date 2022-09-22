//
//  ViewController.swift
//  optimeSecond
//
//  Created by Nyazik Byashimova on 17.09.2022.
//

import UIKit



class NotificationsViewController: UIViewController {
    var vm  = NotificationViewModel()
    @IBOutlet weak var readAllButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timerButton: UIBarButtonItem!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        readAllButton.title = "Read All"
        
        //register cells
        tableView.register(UINib(nibName: "NotificationTableViewSection", bundle: nil), forCellReuseIdentifier: "notificationCell")
        tableView.register(UINib(nibName: "SegmentCell", bundle: nil), forCellReuseIdentifier: "segmentCell")
        vm.refreshTable = { value in
            self.tableView.reloadData()
        }
        vm.startTimer {
            timerButton.title = "Stop"
        }
        vm.appendElemens()
    }
  
    
}


//MARK: - UITableViewDelegate
extension NotificationsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          
          vm.commitEditingStyle(indexPathSection: indexPath.section, indexPath: indexPath) {
              self.tableView.deleteRows(at: [indexPath], with: .automatic)
              self.tableView.reloadData()
          }

      }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        vm.didSelectRowAt(indexPathSection: indexPath.section, indexPath: indexPath) {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource
extension NotificationsViewController : UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfRawInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vm.titleForHeaderInSection(section: section)
    
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == Sections.today.rawValue {
            guard let cell  = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? NotificationTableViewSection else {
                fatalError("cell not found")
            }
            cell.selectionStyle = .none
            let today = vm.cellForRowAt(indexPath: indexPath)
            cell.nameLabel.text = "today"
            cell.nameLabel.text =  today?.first?.model[indexPath.row].name
            cell.messageType.text = today?.first?.model[indexPath.row].messageType
            cell.userImageView.image = today?.first?.model[indexPath.row].img
            cell.readView.isHidden = today?.first?.model[indexPath.row].read ?? false
            
            return cell
        } else if indexPath.section == Sections.yesterday.rawValue {
            guard let cell  = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? NotificationTableViewSection else {
                fatalError("cell not found")
            }
            cell.selectionStyle = .none
            let yesterday = vm.cellForRowAt(indexPath: indexPath)
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
                    guard let notificationModel = self?.vm.notificationModel else { return }
                    for i in 0..<notificationModel.count  {
                        notificationModel[i].model = notificationModel[i].model.filter { $0.messageType == "message request" }
                    }
                    self?.tableView.reloadData()
                } else {
                    self?.vm.appendElemens()
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
            guard let notificationModel = self.vm.notificationModel else { return }
            for i in 0..<notificationModel.count  {
                for j in 0..<notificationModel[i].model.count {
                    if notificationModel[i].model[j].read == false {
                        notificationModel[i].model[j].read = true
                    }
                }
            }
        } else {
            readAllButton.title = "Read All"
            guard let notificationModel = self.vm.notificationModel else { return }
            for i in 0..<notificationModel.count  {
                for j in 0..<notificationModel[i].model.count {
                    notificationModel[i].model[j].read = false
                }
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func timerTapped(_ sender: Any) {
        
        if let title = timerButton.title {
            print(title)
            if title == "Start" {
                vm.startTimer {
                    timerButton.title = "Stop"
                }
            } else {
                timerButton.title = "Start"
                vm.stopTimer()
            }
        }
    }
    
    
}

