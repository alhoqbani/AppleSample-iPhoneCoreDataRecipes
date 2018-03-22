//
//  RecipeDetailTableViewController.swift
//  Recipes
//
//  Created by Hamoud Alhoqbani on 3/19/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

class RecipeDetailTableViewController: UITableViewController, UITextFieldDelegate {

    var recipe: Recipe!
    var ingredients: [Ingredient] = []
    
    private enum Sections {
        static let type = 0, ingredients = 1, instructions = 2
    }
    
    private enum CellsIdentifier {
        static let ingredientsCell = "IngredientsCell"
        static let addIngredientCellIdentifier = "AddIngredientCellIdentifier"
        static let instructions = "Instructions"
        static let recipeType = "RecipeType"
    }
    
    private enum Segue {
        static let addIngredient = "addIngredient"
        static let showInstructions = "showInstructions"
        static let showRecipeType = "showRecipeType"
    }
    
    var singleEdit: Bool = false // Indicates user is swipe-deleting a particular ingredient.
    
    // MARK: Views
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var overviewTextField: UITextField!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var prepTimeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = recipe.name
        
        nameTextField.text = recipe.name
        overviewTextField.text = recipe.overview
        prepTimeTextField.text = recipe.prepTime
        if let image = recipe.thumbnailImage as? UIImage {
            photoButton.setImage(image, for: .normal)
        }
        
        updatePhotoButton()
        
        /*
         Create a mutable array that contains the recipe's ingredients ordered by displayOrder.
         The table view uses this array to display the ingredients.
         Core Data relationships are represented by sets, so have no inherent order.
         Order is "imposed" using the displayOrder attribute, but it would be inefficient to create
         and sort a new array each time the ingredients section had to be laid out or updated.
         */
        ingredients = recipe.ingredients?.allObjects as? [Ingredient] ?? []
        ingredients.sort(by: { $0.displayOrder?.intValue ?? 0 >= $1.displayOrder?.intValue ?? 0 } )
        
        
        
        
//        self.ingredients = sortedIngredients;
        
        // update recipe type and ingredients on return
        self.tableView.reloadData()
        
    }
    
    private func updatePhotoButton() {
        /*
         How to present the photo button depends on the editing state and whether the recipe has a thumbnail image.
         * If the recipe has a thumbnail, set the button's highlighted state to the same as the editing state (it's highlighted if editing).
         * If the recipe doesn't have a thumbnail, then: if editing, enable the button and show an image that says "Choose Photo" or similar; if not editing then disable the button and show nothing.
         */
        
        let editing = isEditing
        
        if recipe.thumbnailImage != nil {
            photoButton.isHighlighted = editing
        } else {
            photoButton.isEnabled = true
            
            if editing {
                photoButton.setImage(#imageLiteral(resourceName: "choosePhoto"), for: .normal)
            } else {
                photoButton.setImage(nil, for: .normal)
            }
        }
    }
    
    // MARK: Actions
    @IBAction func photoButtonTapped(_ sender: Any) {
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
         The number of rows depends on the section.
         In the case of ingredients, if editing, add a row in editing mode to present an "Add Ingredient" cell.
         */
        switch section {
        case Sections.ingredients:
            if isEditing {
                return ingredients.count + 1
            }
            return ingredients.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
    
     // For the Ingredients section, if necessary create a new cell and configure it with
     // an additional label for the amount.  Give the cell a different identifier from that
     // used for cells in other sections so that it can be dequeued separately.
        
        switch indexPath.section {
        case Sections.ingredients:
            let ingredientCount = ingredients.count
            let row = indexPath.row
            
            if row < ingredientCount {
                // If the row is within the range of the number of ingredients for the current recipe,
                // then configure the cell to show the ingredient name and amount.
                //
                cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.ingredientsCell, for: indexPath)
                let ingredient = ingredients[row]
                cell.textLabel?.text = ingredient.name;
                cell.detailTextLabel?.text = ingredient.amount;
            } else {
                // If the row is outside the range, it's the row that was added to allow insertion.
                // (see tableView:numberOfRowsInSection:) so give it an appropriate label.
                //
                cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.addIngredientCellIdentifier, for: indexPath)
            }
            
        case Sections.type:
            cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.recipeType, for: indexPath)
            cell.textLabel?.text = recipe.type?.name ?? "Has not type yet"
        case Sections.instructions:
            cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifier.instructions, for: indexPath)
        default:
            cell = UITableViewCell()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // return a title or nil as appropriate for the section
        switch section {
        case Sections.ingredients:
            return "Ingredients"
        case Sections.type:
            return "Category"
        default:
            return nil
        }
    }
    
    // MARK: - Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if !singleEdit {
            updatePhotoButton()
            nameTextField.isEnabled = true
            overviewTextField.isEnabled = true
            prepTimeTextField.isEnabled = true
            
            navigationItem.hidesBackButton = editing
            
            tableView.beginUpdates()
            
            let ingredientsInsertIndexPath: [IndexPath] = [IndexPath(row: ingredients.count, section: Sections.ingredients)]
            
            if editing {
                tableView.insertRows(at: ingredientsInsertIndexPath, with: .fade)
                self.overviewTextField.placeholder = "Overview..."
            } else {
                tableView.deleteRows(at: ingredientsInsertIndexPath, with: .fade)
            }
            tableView.endUpdates()
        }
        
        /*
         If editing is finished, save the managed object context.
         */
        if !editing {
            if let context = recipe.managedObjectContext {
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        if textField == self.nameTextField {
            recipe.name = textField.text
            navigationItem.title = recipe.name
        }
        if textField == self.overviewTextField {
            recipe.overview = textField.text
        }
        if textField == self.prepTimeTextField {
            recipe.prepTime = textField.text
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        // User has started a swipe to delete operation.
        singleEdit = true
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        // Swipe to delete operation has ended.
        singleEdit = false
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        switch indexPath.section {
        case Sections.type:
            // Edit the recipe "type"- pass the recipe.
            //

            // Present modally the recipe type view controller.

            break
        case Sections.ingredients:
            // Edit the recipe "ingredient" - pass the ingredient.
            //
            
            // Find the selected ingredient table cell (based on indexPath),
            // use it's ingredient title to find the right ingredient object in this recipe.
            // note: you can't use indexPath.row to lookup the recipe's ingredient object because NSSet is not ordered.
            //
            
            // Present modally the ingredient detail view controller.
            //
            
            
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // If editing, don't allow instructions to be selected
        // Not editing: Only allow instructions to be selected
        //
        if ((isEditing && indexPath.section == Sections.instructions) || (!isEditing && indexPath.section != Sections.instructions)) {
            tableView.deselectRow(at: indexPath, animated: true)
            return nil;
        }
        
        return indexPath;

    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        // Only allow editing in the ingredients section.
        // In the ingredients section, the last row (row number equal to the count of ingredients)
        // is added automatically (see tableView:cellForRowAtIndexPath:) to provide an insertion cell,
        // so configure that cell for insertion; the other cells are configured for deletion.
        //
        switch indexPath.section {
        case Sections.ingredients:
            // If this is the last item, it's the insertion row.
            if indexPath.row == ingredients.count {
                return UITableViewCellEditingStyle.insert
            }
            return UITableViewCellEditingStyle.delete
        default:
            return UITableViewCellEditingStyle.none
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Only allow deletion, and only in the ingredients section
        if editingStyle == .delete && indexPath.section == Sections.ingredients {
            // Delete the row from the data source
            // Remove the corresponding ingredient object from the recipe's ingredient list and delete the appropriate table view cell.
            let ingredient = ingredients[indexPath.row]
            recipe.removeFromIngredients(ingredient)
            do {
                try recipe.managedObjectContext?.save()
            } catch {
                fatalError("*** Error remove infredient \(error)")
            }
            
            tableView.deleteRows(at: [indexPath], with: .top)
        } else if editingStyle == .insert {
            // User tapped the "+" button to add a new ingredient.
            performSegue(withIdentifier: Segue.addIngredient, sender: recipe)
        }
    }
    
    // MARK: Moving rows
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        // Moves are only allowed within the ingredients section.
        // Within the ingredients section, the last row (Add Ingredient) cannot be moved.
        return indexPath.row != ingredients.count
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        // Moves are only allowed within the ingredients section, so make sure the destination
        // is in the ingredients section. If the destination is in the ingredients section,
        // make sure that it's not the Add Ingredient row -- if it is, retarget for the penultimate row.
        //
        if proposedDestinationIndexPath.section < Sections.ingredients{
            
            return IndexPath(row: 0, section: Sections.ingredients)
        }
        
        if proposedDestinationIndexPath.section > Sections.ingredients {
            let ingredientsCount_1 = (self.recipe.ingredients?.count)! - 1
            if proposedDestinationIndexPath.row > ingredientsCount_1 {
                return IndexPath(row: ingredientsCount_1, section: Sections.ingredients)
            }
        }
        
        return proposedDestinationIndexPath
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        /*
         Update the ingredients array in response to the move.
         Update the display order indexes within the range of the move.
         */
        // TODO
        print("TODO Implement moving ingredients")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.addIngredient:
            // Add an ingredient.
            //
            guard let navigationVc = segue.destination as? UINavigationController,
                let ingredientDetailTableViewController = navigationVc.topViewController as? IngredientDetailTableViewController else {
                    fatalError("Could not cast vc destenation to RecipeAddViewController")
            }
            
            // The sender is the recipe passed by performSegue
            ingredientDetailTableViewController.recipe = sender as? Recipe
            
        case Segue.showInstructions:
            if let  instructionsController = segue.destination as? InstructionsViewController {
                instructionsController.recipe = recipe
            } else {
                fatalError("Could not cast segue.destination as? InstructionsViewController")
            }
        case Segue.addIngredient:
            print("Segue.addIngredient")
        default:
            break
        }
    }

}
