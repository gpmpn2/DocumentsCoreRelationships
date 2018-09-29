//
//  DocumentsTableViewCell.swift
//  DocumentsCoreRelationships
//
//  Created by Grant Maloney on 9/28/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
