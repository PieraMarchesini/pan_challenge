//
//  DetailTitleTableViewCell.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 22/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class DetailTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabelOutlet: UILabel!
    
    var detailedGame: Games.Game? {
        didSet {
            self.titleLabelOutlet.text = self.detailedGame?.game.name
        }
    }
}
