//
//  TableViewController.swift
//  MemeMeApp
//
//  Created by Gustavo Brunetto on 2020-04-19.
//  Copyright © 2020 Gustavo Brunetto. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    private let reusableIdentifier = "Cell"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.title = "Memes List"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(generateMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appDelegate.memesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath)

        // Configure the cell...
        if let cell = cell as? TableViewCell {
            let topText = appDelegate.memesList[indexPath.row].topText
            let bottomText = appDelegate.memesList[indexPath.row].bottomText
            cell.memeText?.text = "\(topText)...\(bottomText)"
            cell.memeImage?.image = appDelegate.memesList[indexPath.row].memedImage
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let infoMemeViewControl = self.storyboard?.instantiateViewController(identifier: "MemeInfo") as! MemeInfoViewController
        infoMemeViewControl.meme = appDelegate.memesList[indexPath.row]
        navigationController?.pushViewController(infoMemeViewControl, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        self.hidesBottomBarWhenPushed = true
    }
    */
    
    
    @objc func generateMeme() {
        let viewController = storyboard?.instantiateViewController(identifier: "MakeMeme") as! ViewController
        
        viewController.tableViewController = self
        present(viewController, animated: true, completion: nil)
    }
    

}
