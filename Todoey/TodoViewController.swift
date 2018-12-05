//
//  ViewController.swift
//  Todoey
//
//  Created by Happy on 05/12/18.
//  Copyright © 2018 Happy. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    var ItemArray = ["eat","bath","sleep"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  ItemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todocell", for: indexPath)
        cell.textLabel?.text=ItemArray[indexPath.row]
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(ItemArray[indexPath.row])
       if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
       {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
       {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func AddItem(_ sender: UIButton) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add new TODO item", message: "", preferredStyle: .alert)
        let Action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.ItemArray.append(textfield.text!)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="create new item"
            textfield=alertTextField
        }
        alert.addAction(Action)
        present(alert,animated: true,completion: nil)
        
        
        
        
        
        
        
        
    }
    
    
}

