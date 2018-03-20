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
        
        print("cancelButtonTapped")
        recipe.managedObjectContext?.delete(recipe)
        
        delegate?.controller(recipeAddViewController: self, didAddRecipe: nil)
        
        
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        print("saveButtonTapped")
    }
}

extension RecipeAddViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        return true
    }
}


protocol RecipeAddDelegate {
    
    func controller(recipeAddViewController controller: RecipeAddViewController, didAddRecipe recipe: Recipe?)
    
}



