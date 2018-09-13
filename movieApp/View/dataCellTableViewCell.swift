//
//  dataCellTableViewCell.swift
//  movieApp
//
//  Created by Amit Mathur on 9/4/18.
//  Copyright © 2018 Amit Mathur. All rights reserved.
//

import UIKit

class dataCellTableViewCell: UITableViewCell {

    @IBOutlet var movieName: UILabel!
    @IBOutlet var movieRealeaseDate: UILabel!
    @IBOutlet var movieOverview: UILabel!
    @IBOutlet var moviePoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
