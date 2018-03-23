//
//  GameCollectionViewCell.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 22/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit
import SDWebImage

class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    
    var game: Games.Game? {
        didSet {
            self.titleOutlet.text = self.game?.game.name
            if let image = self.game?.game.box.large {
                self.imageOutlet.sd_setShowActivityIndicatorView(true)
                self.imageOutlet.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "backgroundImage"), options: .highPriority, completed: nil)
            } else {
                self.imageOutlet.image = #imageLiteral(resourceName: "backgroundImage")
            }
            self.imageOutlet.contentMode = .scaleAspectFill
        }
    }
}
