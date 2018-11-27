//
//  ViewController.swift
//  scrm
//
//  Created by astarodub on 10/23/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    static var categories: [Category] = []
    static var reminders: [Reminder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            didAllow, error in
            if !didAllow {
                self.showAlertMessage(title: "Notifications", msg: "You will not receive event notifications!")
            }
        }
        
        setupReminderHandlers()
        loadReminders()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let (login_, pswd_, _) = UserUtils.loadUserData()
        
        if let login = login_, let pswd = pswd_ {
            UserUtils.loginUser(login: login, password: pswd) { response in
                switch response {
                case .error(_):
                    self.performSegue(withIdentifier: "showLoginViewSegue", sender: self)
                case .success(_):
                    self.loadCategories()
                }
            }
        } else {
            self.performSegue(withIdentifier: "showLoginViewSegue", sender: self)
        }
    }
    
    func loadCategories() {
        let url = NetUtils.fetchCategories() { response in
            switch response {
            case .error(let message): self.showAlertMessage(title: "Error", msg: message)
            case .success(let json): self.parseAndShow(json)
            }
        }
        
        if let json = Cache.loadFromCache(url: url) {
            parseAndShow(json)
        }
    }
    
    func parseAndShow(_ json: [String: Any]) {
        ViewController.categories = JsonUtils.parseCategories(json)
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell
        
        let idx = indexPath.row
        
        if idx < ViewController.categories.count {
            let category = ViewController.categories[idx]
            cell.iconImage.image = UIImage(named: "category.png")
            
            cell.nameLabel.text = category.name
            cell.nameLabel.tag = category.id
            self.addAction(cell.nameLabel, action:#selector(ViewController.tapCategory))
        }
        
        return cell
    }
    
    @objc
    func tapCategory(sender:UITapGestureRecognizer) {
        let categoryLabel = sender.view as! UILabel
        PeopleViewController.categoryId = categoryLabel.tag
        
        performSegue(withIdentifier: "showContactsSegue", sender: self)
    }
    
    func addNotification(_ id: Int, title: String, body: String, time: TimeInterval) {
        // create notificaiton
        let content = UNMutableNotificationContent()
        content.title = "SCRM Event"
        content.subtitle = title
        content.body = body
        content.badge = 1
        
        // trigger notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let request = UNNotificationRequest(identifier: "scrm-\(id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func loadReminders() {
        NetUtils.fetchReminders() { response in
            switch response {
            case .error(let message):
                self.showAlertMessage(title: "Error", msg: message)
            case .success(let json):
                self.parseReminders(json)
            }
        }
    }
    
    func parseReminders(_ json: [String: Any]) {
        ViewController.reminders = JsonUtils.parseReminders(json)
        
        for rem in ViewController.reminders {
            // remove notification if already exists
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["scrm-\(rem.tid)"])
            
            guard let time = Date.fromMysql(rem.time) else { continue }
            let timeDiff = time.timeIntervalSince(Date())
            if timeDiff < 0 { continue }
            
            print("\(rem.title) ---- \(timeDiff)")
            
            addNotification(rem.tid, title: rem.title, body: rem.body, time: timeDiff)
        }
    }
    
    func setupReminderHandlers() {
        
    }
}
