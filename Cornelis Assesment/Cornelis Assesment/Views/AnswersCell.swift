//
//  AnswersCell.swift
//  Cornelis Assesment
//
//  Created by Cornelis Kuijpers on 2020/06/09.
//  Copyright © 2020 Cor Kuijpers. All rights reserved.
//

import UIKit

class AnswersCell: UITableViewCell {

    
    @IBOutlet weak var imgAnswered: UIImageView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtBody: UILabel!
    @IBOutlet weak var txtAskedBy: UILabel!
    @IBOutlet weak var txtTotalAnswers: UILabel!
    @IBOutlet weak var txttotalVotes: UILabel!
    @IBOutlet weak var txtTotalViews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
