//
//  FailedToFetchDataViewController.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 23/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class FailedToFetchDataViewController: UIViewController {

    enum InstanceErrors:Error {
        case couldNotLoadStoryboard
        case couldNotCast
    }
    
    @IBOutlet weak var messageLabelOutlet: UILabel!
    var message:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class func instanceView(with message:String) throws -> UIView {
        
        let storyboard = UIStoryboard(name: "Auxiliar", bundle: Bundle.main)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "FailedToFetchDataViewController") as? FailedToFetchDataViewController else {
            throw InstanceErrors.couldNotCast
        }
        viewController.message = "Failed to get the popular games from Twitch. "+message
        return viewController.view
    }

}
