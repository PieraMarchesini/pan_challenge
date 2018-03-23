//
//  DetailGameTableViewController.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 22/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class DetailGameTableViewController: UITableViewController {
    
    var detailedGame: Games.Game?
    var dataManager: DataManager?
    var headerView: DetailHeaderView!
    var headerMaskLayer: CAShapeLayer!
    private let tableHeaderViewHeight: CGFloat = 460.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.navigationItem.largeTitleDisplayMode = .never
        
        //Set up the stretchy header effect
        if let headerView = tableView.tableHeaderView as? DetailHeaderView {
            self.headerView = headerView
            if let image = self.detailedGame?.game.box.large {
                self.headerView.imageView.sd_setShowActivityIndicatorView(true)
                
                self.headerView.imageView.sd_setImage(with: URL(string: image) , placeholderImage: #imageLiteral(resourceName: "backgroundImage"), options: .highPriority, completed: nil)
            } else {
                self.headerView.imageView.image = #imageLiteral(resourceName: "backgroundImage")
            }
            self.headerView.imageView.contentMode = .scaleAspectFill
            self.tableView.tableHeaderView = nil
            self.tableView.addSubview(headerView)
            
            self.tableView.contentInset = UIEdgeInsets(top:
                self.tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
            self.tableView.contentOffset = CGPoint(x: 0, y: -self.tableHeaderViewHeight)
            
            let effectiveHeight = self.tableHeaderViewHeight
            self.tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
            self.tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
            
            self.updateHeaderView()
        }
    }
    
    // MARK: - Stretchy header effect
    func updateHeaderView() {
        let effectiveHeight = self.tableHeaderViewHeight
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: self.tableView.bounds.width, height: self.tableHeaderViewHeight)
        if self.tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = self.tableView.contentOffset.y
            headerRect.size.height = -self.tableView.contentOffset.y
        }
        self.headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height))
        
        self.headerMaskLayer?.path = path.cgPath
    }
    
    // MARK: - ScrollView method
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateHeaderView()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let game = self.detailedGame else { return UITableViewCell() }
        if indexPath.row == 0 {
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: "detailTitleCell", for: indexPath) as? DetailTitleTableViewCell else { return UITableViewCell() }
            titleCell.detailedGame = game
            return titleCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailInfoCell", for: indexPath) as? DetailInfoTableViewCell else { return UITableViewCell() }
            switch indexPath.row {
            case 1:
                cell.categoryLabelOutlet.text = "Channels"
                cell.descriptionLabelOutlet.text = "\(game.channels)"
            case 2:
                cell.categoryLabelOutlet.text = "Viewers"
                cell.descriptionLabelOutlet.text = "\(game.viewers)"
            default:
                break
            }
            return cell
        }
    }
}
