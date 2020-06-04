//
//  TableViewController.swift
//  course2
//
//  Created by Cesar Nascimento on 29/05/20.
//  Copyright © 2020 Cesar Nascimento. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let shareOptions = [
        "Facebook",
        "Google",
        "Instagram",
        "Whatsapp"
    ]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(shareOptions[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareCell", for: indexPath)
        
        cell.textLabel?.text = shareOptions[indexPath.row]
        
        return cell
    }
}
