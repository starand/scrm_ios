//
//  TasksViewController.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func loadTasks() {
        NetUtils.fetchTasks(24) { response in
            switch response {
            case .error(let message):
                print(message)
            case .success(let json):
                var tasks: [Task] = JsonUtils.parseTasks(json)
                //self.displayTasks()
            }
        }
    }
}
