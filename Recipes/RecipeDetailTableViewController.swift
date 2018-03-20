//
//  RecipeDetailTableViewController.swift
//  Recipes
//
//  Created by Hamoud Alhoqbani on 3/19/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

class RecipeDetailTableViewController: UITableViewController {
    
    var recipe: Recipe!
    var ingredient: [Ingredient] = []

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
        ingredient = recipe.ingredients?.allObjects as? [Ingredient] ?? []
        ingredient.sort(by: { $0.displayOrder?.intValue ?? 0 >= $1.displayOrder?.intValue ?? 0 } )
        
        
        
        
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
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
