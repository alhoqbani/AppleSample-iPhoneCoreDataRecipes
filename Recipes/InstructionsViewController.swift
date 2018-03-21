//
//  InstructionsViewController.swift
//  Recipes
//
//  Created by Hamoud Alhoqbani on 3/20/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Instructions"
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = recipe.name
        instructionsTextView.text = recipe.instructions
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        instructionsTextView.isEditable = editing
        navigationItem.setHidesBackButton(editing, animated: true)
        
        if !editing {
            recipe.instructions = instructionsTextView.text
            if let context = recipe.managedObjectContext, context.hasChanges {
                do {
                    try context.save()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
        
    }
}
