//
//  ViewController.swift
//  Swift3CoreDataApp
//
//  Created by Spot Matic SL on 21/10/16.
//  Copyright © 2016 Spot Matic SL. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
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
            people = resul
        }catch let error as NSError {
            NSLog("Error \(error): \(error.userInfo) ")
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
        
    }//end addName IBAction
    
    
    
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let person = people[indexPath.row]
        cell!.textLabel!.text = person.value(forKey: "name") as? String
        return cell!
    }
    
    //end UITableViewDataSource
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = self.people[indexPath.row]
        let oldName = person.value(forKey: "name")
        
        let alert = UIAlertController( title: "¿Modificamos o Eliminamos?",
                                       message: "Escribe el nuevo nombre para modificarlos",
                                       preferredStyle: .alert)
        
        alert.addTextField { (textFiled) in }
        
        let updateAction = UIAlertAction(title: "Modificar", style: .default) { (alertAction) in
            let newName = alert.textFields!.first!.text!
            person.setValue( newName, forKey: "name")
            
            self.updateName( person: person, oldName : oldName as! String  )
            
            self.people.remove(at: indexPath.row)
            self.people.insert(person, at: indexPath.row)
            self.tableView.reloadData();
        }

        let deleteAction = UIAlertAction(title: "Borarr", style: .destructive) { (alertAction) in
            self.deleteName( person : person )
            self.people.remove(at: indexPath.row)
            self.tableView.reloadData();
        }
        
        alert.addAction( updateAction )
        alert.addAction( deleteAction )
        
        present(alert, animated: true, completion: nil)
    }//end didSelectRowAt
    
    
    
    //MARK: Guardar Nombre en CoreData
    func saveName(name: String) {
        
        //1 Obtener clase AppDelete para obtener contexto de persistencia
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //2 Selecciona entidad para trabajar
        let entity =  NSEntityDescription.entity(forEntityName: "Person", in: context)
 
        //3 Crear NSManagedObject en modo inserccion
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        //4 setear datos a modificar
        person.setValue(name, forKey: "name")
        
        //5 controlar entre do catch operacion de salvar, usar try
        do {
            try context.save()
            
            //actualizar el array
            people.append(person)
            
        } catch let error as NSError  {
            NSLog("Could not save \(error), \(error.userInfo)")
        }
    }//end saveName
    
    
    func deleteName( person : NSManagedObject ){
        NSLog("Eliminamos persona")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(person)
        
        do {
           try context.save()
        } catch let error as NSError  {
            NSLog("Could not Delete \(error), \(error.userInfo)")
        }
    }//end deleteName
    
    
    func updateName( person : NSManagedObject, oldName : String ){
        NSLog("Modifcamos nombre")
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fecthRequest : NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Person")
        fecthRequest.predicate = NSPredicate(format: "name = %@", oldName )
        
        do {
            let resul = try context.fetch(fecthRequest)
            if resul.count == 1 {
                let managedObject = resul[0]
                managedObject.setValue(person, forKey: "name")
                try context.save()
            }
            
        } catch let error as NSError  {
            NSLog("Could not Delete \(error), \(error.userInfo)")
        }

    }//end updateName
    
}

