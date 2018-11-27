//
//  PeopleViewController.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    static var categoryId: Int = 0
    static var contacts: [Contact] = []
    var sortedContacts: [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PeopleViewController.categoryId >= 0 {
            loadContactList()
        }
    }

    func loadContactList() {
        let url = NetUtils.fetchContacts() { response in
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
        PeopleViewController.contacts = JsonUtils.parseContacts(json)
        
        sortedContacts = []
        for contact in PeopleViewController.contacts {
            if contact.cat == PeopleViewController.categoryId {
                sortedContacts.append(contact)
            }
        }
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactTableViewCell
        
        let idx = indexPath.row
        if idx < sortedContacts.count {
            cell.nameLabel.text = sortedContacts[idx].name
            cell.nameLabel.tag = sortedContacts[idx].id
            cell.contactImage.image = UIImage(named: "contact_man.png")
            cell.mailImage.image = UIImage(named: "mail-to.png")
            cell.mailImage.tag = idx
            cell.noteImage.image = UIImage(named: "add-note.png")
            cell.noteImage.tag = idx
            cell.phoneImage.image = UIImage(named: "phone.png")
            cell.phoneImage.tag = idx
            
            self.addAction(cell.nameLabel, action:#selector(PeopleViewController.tapPerson))
            self.addAction(cell.phoneImage, action:#selector(PeopleViewController.callPerson))
            self.addAction(cell.mailImage, action:#selector(PeopleViewController.mailPerson))
            self.addAction(cell.noteImage, action:#selector(PeopleViewController.notePerson))
        }
        
        return cell
    }
    
    @objc
    func tapPerson(sender:UITapGestureRecognizer) {
        let personLabel = sender.view as! UILabel
        PersonViewController.personId = personLabel.tag
        
        performSegue(withIdentifier: "showContactSegue", sender: self)
    }
    
    @objc
    func callPerson(sender:UITapGestureRecognizer) {
        let callImage = sender.view as! UIImageView
        let phone = sortedContacts[callImage.tag].phone
        
        guard let number = URL(string: "tel://" + phone) else { return }
        UIApplication.shared.open(number)
    }
    
    @objc
    func mailPerson(sender:UITapGestureRecognizer) {
        let mailImage = sender.view as! UIImageView
        let mail = sortedContacts[mailImage.tag].mail
        
        guard let number = URL(string: "mailto:" + mail) else { return }
        UIApplication.shared.open(number)
    }
    
    @objc
    func notePerson(sender:UITapGestureRecognizer) {
        let noteImage = sender.view as! UIImageView
        PersonViewController.personId = sortedContacts[noteImage.tag].id

        performSegue(withIdentifier: "showAddNoteSegue", sender: self)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        sortedContacts = PeopleViewController.contacts
        self.table.reloadData()
    }
}
