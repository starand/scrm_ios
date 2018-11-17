//
//  HistoryViewController.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

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

    func loadNotes() {
        NetUtils.fetchNotes(30) { response in
            switch response {
            case .error(let message):
                print(message)
            case .success(let json):
                print(json)
                var notes: [Note] = JsonUtils.parseNotes(json)
                //self.displayTasks()
            }
        }
    }
}
