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
        
        self.navigationItem.title = "Memes List"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(generateMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let infoMemeViewControl = self.storyboard?.instantiateViewController(identifier: "MemeInfo") as! MemeInfoViewController
        infoMemeViewControl.meme = appDelegate.memesList[indexPath.row]
        navigationController?.pushViewController(infoMemeViewControl, animated: true)
    }
    
    
    @objc func generateMeme() {
        let viewController = storyboard?.instantiateViewController(identifier: "MakeMeme") as! MemeEditorViewController
        
        viewController.tableViewController = self
        present(viewController, animated: true, completion: nil)
    }
    

}
