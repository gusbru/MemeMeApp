//
//  CollectionViewController.swift
//  MemeMeApp
//
//  Created by Gustavo Brunetto on 2020-04-19.
//  Copyright © 2020 Gustavo Brunetto. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Memes Collection"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(generateMeme))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let memeInfoViewController = self.storyboard?.instantiateViewController(identifier: "MemeInfo") as! MemeInfoViewController
        memeInfoViewController.meme = appDelegate.memesList[indexPath.row]
        navigationController?.pushViewController(memeInfoViewController, animated: true)
        
    }
    
    @objc func generateMeme() {
        let viewController = self.storyboard?.instantiateViewController(identifier: "MakeMeme") as! MemeEditorViewController
        
        viewController.collectionViewController = self
        present(viewController, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return appDelegate.memesList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        if let cell = cell as? CollectionViewCell {
            cell.cellImage?.image = appDelegate.memesList[indexPath.row].memedImage
        }
    
        return cell
    }

}
