//
//  CategoryViewController.swift
//  FlashCat
//
//  Created by Happy on 15/05/19.
//  Copyright © 2019 Happy. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    let Context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var ArrayName = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayName.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "use", for: indexPath)
        let category = ArrayName[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = ArrayName[indexPath.row]
        }
    }
    @IBAction func AddItem(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Do You want to add something", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add something", style: .default) { (action) in
            let newItem = Category(context: self.Context)
            newItem.name = textField.text!
          
            self.ArrayName.append(newItem)
            self.SaveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    func SaveItems() {
        do {
            try Context.save()
        }catch{
            print("Error encoding item array \(error)")
        }
        tableView.reloadData()
    }
    func loadItems()  {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
 
        do {
           ArrayName = try Context.fetch(request)
        }catch {
            print("Error decoding item array \(error)")
        }
        tableView.reloadData()
    }
        
        
    }
    

