//
//  IngredientDetailTableViewController.swift
//  Recipes
//
//  Created by Hamoud Alhoqbani on 3/20/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

class IngredientDetailTableViewController: UITableViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    var recipe: Recipe!
    var ingredientStr = ""
    var amountStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        title = "Ingredient"
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = false
        
    }
    
    // MARK: - Actions
    @IBAction func save(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditingTableViewCell.identifier, for: indexPath) as! EditingTableViewCell
        
        // Configure the cell...
        
        if indexPath.row == 0 {
            // Cell ingredient name.
            cell.titleLabel.text = "Ingredient"
            cell.inputTextField.text = ingredientStr
            cell.inputTextField.placeholder = "Name"
            cell.inputTextField.tag = 1;
        }
        
        if indexPath.row == 1 {
            // Cell ingredient amount.
            cell.titleLabel.text = "Amount"
            cell.inputTextField.text = amountStr
            cell.inputTextField.placeholder = "Amount"
            cell.inputTextField.tag = 2;

        }


        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
