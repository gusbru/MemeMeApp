//
//  MemeInfoViewController.swift
//  MemeMeApp
//
//  Created by Gustavo Brunetto on 2020-04-20.
//  Copyright © 2020 Gustavo Brunetto. All rights reserved.
//

import UIKit

class MemeInfoViewController: UIViewController {
    
    var meme: Meme?
    @IBOutlet weak var memeTitle: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.title = "Meme Info"
        
        // populate meme info
        if let meme = meme {
            memeImage.image = meme.memedImage
            memeTitle.text = "\(meme.topText)...\(meme.bottomText)"
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = false
    }

}
