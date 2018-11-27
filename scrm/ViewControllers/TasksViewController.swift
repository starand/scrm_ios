//
//  TasksViewController.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    static var tasks: [Task] = []
    var heights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PersonViewController.personId >= 0 {
            loadTasks(personId: PersonViewController.personId)
        }
    }

    func loadTasks(personId: Int) {
        let url = NetUtils.fetchTasks(personId) { response in
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
        TasksViewController.tasks = JsonUtils.parseTasks(json)
        
        if TasksViewController.tasks .count > 0 {
            heights = Array(repeating: 0.0, count: TasksViewController.tasks .count)
        }
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TasksViewController.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTableViewCell
        
        let idx = indexPath.row
        if idx < TasksViewController.tasks.count {
            let task = TasksViewController.tasks[idx]
            
            cell.titleLabel.text = task.title
            cell.dateLabel.text = task.time
            
            cell.contentLabel.numberOfLines = 0
            cell.contentLabel.text = task.desc
            if idx < heights.count {
                heights[idx] = cell.contentLabel.bounds.size.height
            }
            
            cell.taskImage.image = UIImage(named: "task.png")
            cell.trashImage.image = UIImage(named: "trash.png")
            cell.trashImage.tag = task.id

            self.addAction(cell.trashImage, action:#selector(TasksViewController.tapTrash))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let idx = indexPath.row
        if idx < heights.count && heights[idx] > 0 {
            return 22.0 + heights[idx]
        }
        
        return UITableView.automaticDimension
    }
    
    @objc
    func tapTrash(sender:UITapGestureRecognizer) {
        let image = sender.view as! UIImageView
        
        let contactId = PersonViewController.personId
        let delId = image.tag
        
        NetUtils.deleteTask(delId, contactId: contactId) { response in
            switch response {
            case .error(let message):
                self.showAlertMessage(title: "Error", msg: message)
            case .success(_):
                self.loadTasks(personId: contactId)
            }
        }
    }
}
