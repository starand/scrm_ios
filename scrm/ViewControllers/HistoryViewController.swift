//
//  HistoryViewController.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!

    var notes: [Note] = []
    var heights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PersonViewController.personId >= 0 {
            loadNotes(personId: PersonViewController.personId)
        }
    }

    func loadNotes(personId: Int) {
        let url = NetUtils.fetchNotes(personId) { response in
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
        notes = JsonUtils.parseNotes(json)
        
        if notes.count > 0 {
            heights = Array(repeating: 0.0, count: notes.count)
        }
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! NoteTableViewCell
        
        let idx = indexPath.row
        if idx < notes.count {
            let note = notes[idx]
            
            cell.titleLabel.text = note.title
            cell.dateLabel.text = note.time
            
            cell.contentLabel.numberOfLines = 0
            cell.contentLabel.text = note.message
            if idx < heights.count {
                heights[idx] = cell.contentLabel.bounds.size.height
            }
            
            cell.noteImage.image = UIImage(named: "note.ico")
            cell.trashImage.image = UIImage(named: "trash.png")
            cell.trashImage.tag = note.id
            
            self.addAction(cell.trashImage, action:#selector(HistoryViewController.tapTrash))
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
        
        NetUtils.deleteNote(delId, contactId: contactId) { response in
            switch response {
            case .error(let message):
                self.showAlertMessage(title: "Error", msg: message)
            case .success(_):
                self.loadNotes(personId: contactId)
            }
        }
    }
    
}
