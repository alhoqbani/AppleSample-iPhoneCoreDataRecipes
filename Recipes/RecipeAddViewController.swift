//
//  RecipeAddViewController.swift
//  Recipes
//
//  Created by Hamoud Alhoqbani on 3/19/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

class RecipeAddViewController: UIViewController {
    
    
    var recipe: Recipe!
    var delegate: RecipeAddDelegate?

    
    // MARK: Views
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        
    }
    
    // MARK: Actions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        // Delete the recipe from the context
        recipe.managedObjectContext?.delete(recipe)
        // Save the changes to delete the object from the context
        if let context = recipe.managedObjectContext, context.hasChanges {
            try! context.save()
        }
        // Call the delegate without a recipe.
        delegate?.controller(recipeAddViewController: self, didAddRecipe: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        saveRecipe()
    }
    
    private func saveRecipe() {
        recipe.name = nameTextField.text
        if let context = recipe.managedObjectContext, context.hasChanges {
            try! context.save()
        }
        
        delegate?.controller(recipeAddViewController: self, didAddRecipe: recipe)
    }
}

extension RecipeAddViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveRecipe()
        nameTextField.resignFirstResponder()
        return true
    }
    
}


protocol RecipeAddDelegate {
    
    func controller(recipeAddViewController controller: RecipeAddViewController, didAddRecipe recipe: Recipe?)
    
}



