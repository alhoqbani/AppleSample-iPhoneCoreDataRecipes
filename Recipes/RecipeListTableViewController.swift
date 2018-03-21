//
//  RecipeListTableViewController.swift
//  Recipes
//
//  Created by Hamoud Alhoqbani on 3/19/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit
import CoreData

class RecipeListTableViewController: UITableViewController {
    
    private enum Segue {
        static let addRecipe = "addRecipe"
        static let showRecipe = "showRecipe"
    }
    
    var managedObjectContext: NSManagedObjectContext?
    lazy var fetchedResultsController: NSFetchedResultsController<Recipe> = {
        guard let context = self.managedObjectContext else {
            fatalError("Could not create fetchedResultsController: no managedObjectContext")
        }
        
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        // Edit the sort key as appropriate.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // Add the table's edit button to the left side of the nav bar.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Set the table view's row height.
        self.tableView.rowHeight = 44.0;
        
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = fetchedResultsController.sections?[section] {
                return sectionInfo.numberOfObjects
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         // Dequeue a RecipeTableViewCell, then set its recipe to the recipe for the current row.
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell

        // Configure the cell...
        cell.recipe = fetchedResultsController.object(at: indexPath)

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.addRecipe:
            guard let navigationVc = segue.destination as? UINavigationController,
                let recipeAddViewController = navigationVc.topViewController as? RecipeAddViewController else {
                fatalError("Could not cast vc destenation to RecipeAddViewController")
            }
            recipeAddViewController.recipe = Recipe(context: self.managedObjectContext!)
            recipeAddViewController.delegate = self
            
        case Segue.showRecipe:
            var recipe: Recipe
            // The sender is the actual recipe send from "didAddRecipe" delegate (user created a new recipe).
            if sender is Recipe {
                recipe = sender as! Recipe
            } else {
                // The sender is ourselves (user tapped an existing recipe).
                let indexPath = tableView.indexPathForSelectedRow!
                recipe = fetchedResultsController.object(at: indexPath)
            }
            
            
            guard let recipeDetailTableViewController = segue.destination as? RecipeDetailTableViewController else {
                fatalError("segue.destination is not RecipeDetailTableViewController")
            }
            
            recipeDetailTableViewController.recipe = recipe
            
        default:
            fatalError("Unknown segue.identifier: \(String(describing: segue.identifier))")
        }
            
        // Pass the selected object to the new view controller.
    }

}

extension RecipeListTableViewController: RecipeAddDelegate {
    
    
    func controller(recipeAddViewController controller: RecipeAddViewController, didAddRecipe recipe: Recipe?) {
        
        if let recipe = recipe {
            print("present details controller")
            
            performSegue(withIdentifier: Segue.showRecipe, sender: recipe)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension RecipeListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            tableView.cellForRow(at: indexPath!)
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let set = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(set, with: .fade)
        case .delete:
            tableView.deleteSections(set, with: .fade)
        case .move:
            fallthrough
        case .update:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // The fetch controller has sent all current change notifications,
        // so tell the table view to process all updates.
        tableView.endUpdates()
    }
    
}




