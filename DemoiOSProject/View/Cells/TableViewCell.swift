//
//  TableViewCell.swift
//  DemoTest
//
//  Created by Sahil Garg on 21/07/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var cellItem: AnimeModel? {
        didSet {
            if let item = cellItem {
                nameLabel.text = item.title
            }
        }
    }
    
    
}
