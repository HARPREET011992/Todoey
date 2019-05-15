//
//  ViewController.swift
//  FlashCat
//
//  Created by Happy on 12/05/19.
//  Copyright © 2019 Happy. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    let Context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Property.plist")
    var Array = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(dataFilePath!)
       
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return Array.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse",for: indexPath)
        let item = Array[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
               return cell
        

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Array[indexPath.row].done = !Array[indexPath.row].done
         Context.delete(Array[indexPath.row])
       Array.remove(at: indexPath.row)
       
        SaveItems()
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    @IBAction func AddItem(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Do You want to add something", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add something", style: .default) { (action) in
            let newItem = Item(context: self.Context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentcategory = self.selectedCategory
            
            self.Array.append(newItem)
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
    func loadItems(with request:NSFetchRequest<Item>=Item.fetchRequest(),predicate:NSPredicate?=nil )  {
    let categoryPredicate = NSPredicate(format: "parentcategory.name MATCHES %@", selectedCategory!.name!)
       
        if let addtionalPredicate = predicate{
            request.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
            do {
             Array = try Context.fetch(request)
            }catch {
                print("Error decoding item array \(error)")
            }
    tableView.reloadData()
    }

   
    
}
extension TableViewController :UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         let request :NSFetchRequest<Item> = Item.fetchRequest()
        let predicate   = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
       loadItems(with: request,predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
