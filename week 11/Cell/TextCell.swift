//
//  TextCell.swift
//  11_CustomTables
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class CellOnlyText: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func setCell(title:String){
        titleLabel.text = title
    }
}
