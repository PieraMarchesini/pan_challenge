//
//  LoadingViewController.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 23/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    enum InstanceErrors:Error {
        case couldNotLoadStoryboard
        case couldNotCast
    }
    
    @IBOutlet weak var outletActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.outletActivityIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.outletActivityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.outletActivityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instanceView() throws -> UIView {
        
    
        let storyboard = UIStoryboard(name: "Auxiliar", bundle: Bundle.main)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController else {
            throw InstanceErrors.couldNotCast
        }
        
        return viewController.view
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
