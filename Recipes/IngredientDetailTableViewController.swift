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
    var ingredient: Ingredient?
    var ingredientStr: String?
    var amountStr: String?


    private enum TextFieldTag {
        static let name = 1
        static let amount = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Ingredient"
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = false
    }

    // MARK: - Save and cancel Actions
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let context = recipe.managedObjectContext else {
            fatalError("Could not get context from recipe")
        }

        // If there isn't an ingredient object, create and configure one.
        if ingredient == nil {
            ingredient = Ingredient(context: context)
            ingredient!.displayOrder = (recipe.ingredients?.count ?? 0) as NSNumber
            ingredient!.name = ingredientStr
            ingredient!.amount = amountStr
            recipe.addToIngredients(ingredient!)
        }

        // Update the ingredient from the values in the text fields.
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EditingTableViewCell
        nameCell.inputTextField.text = ingredient?.name

        let amountCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! EditingTableViewCell
        amountCell.inputTextField.text = ingredient?.amount


        // Save the managed object context.
        do {
            try  context.save()
        } catch {
            fatalError(error.localizedDescription)
        }

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
            cell.inputTextField.tag = TextFieldTag.name;
            cell.inputTextField.delegate = self
        }
        
        if indexPath.row == 1 {
            // Cell ingredient amount.
            cell.titleLabel.text = "Amount"
            cell.inputTextField.text = amountStr
            cell.inputTextField.placeholder = "Amount"
            cell.inputTextField.tag = TextFieldTag.amount;
            cell.inputTextField.delegate = self
        }


        return cell
    }
}

extension IngredientDetailTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        // Editing has ended in one of our text fields, assign it's text to the right
        // ivar based on the view tag.
        //
        switch textField.tag {
            case TextFieldTag.name:
                ingredientStr = textField.text
            case TextFieldTag.amount:
                amountStr = textField.text
            default:
                break
        }
    }
}
