//
//  CellPicture.swift
//  11_CustomTables
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class CellWithPicture: UITableViewCell {
    
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setCell(title:String, image:UIImage){
        print("set cell")
        titleLabel.text = title
        noteImage.image = image
    }
    
}
