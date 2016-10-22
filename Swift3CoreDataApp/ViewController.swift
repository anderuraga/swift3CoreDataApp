//
//  ViewController.swift
//  Swift3CoreDataApp
//
//  Created by Spot Matic SL on 21/10/16.
//  Copyright © 2016 Spot Matic SL. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var names = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        title = "Listado Nombres"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
                                        self.names.append(textField!.text!)
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
        return names.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell!.textLabel!.text = names[indexPath.row]
        return cell!
    }
    
    
    
}

