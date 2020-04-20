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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
