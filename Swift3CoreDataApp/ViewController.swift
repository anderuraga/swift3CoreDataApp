//
//  ViewController.swift
//  Swift3CoreDataApp
//
//  Created by Spot Matic SL on 21/10/16.
//  Copyright © 2016 Spot Matic SL. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    //var names = [String]()
    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        title = "Listado Nombres"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
 
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Person")
        
        do {
            let resul = try context.fetch(fetchRequest)
            people = resul as! [NSManagedObject]
        }catch let error as NSError {
            print("Error \(error): \(error.userInfo) ")
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Implement the addName IBAction
    @IBAction func addName(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Nuevo Nombre",
                                      message: "Añade un nombre",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Salvar",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveName(name: textField!.text ?? "" )
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default) { (action: UIAlertAction) -> Void in }
        
        alert.addTextField { (textFiled) in }
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present( alert, animated: true, completion: nil)
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let person = people[indexPath.row]
        cell!.textLabel!.text = person.value(forKey: "name") as! String
        return cell!
    }
    
    //MARK: CRUD 
    func saveName(name: String) {
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "Person", in: context)
        
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        
        //3
        person.setValue(name, forKey: "name")
        
        //4
        do {
            try context.save()
            //5
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}

