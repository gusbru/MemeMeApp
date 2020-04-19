//
//  TableViewCell.swift
//  MemeMeApp
//
//  Created by Gustavo Brunetto on 2020-04-19.
//  Copyright © 2020 Gustavo Brunetto. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var memeImage: UIImageView?
    @IBOutlet var memeText: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
