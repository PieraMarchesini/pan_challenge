//
//  GamesCollectionViewController.swift
//  TwitchGames
//
//  Created by Piera Marchesini on 22/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit
import Reachability

private let reuseIdentifier = "Cell"

class GamesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NetworkStatusListener {
    private let dataManager = DataManager.sharedInstance
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPullToRefresh()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReachabilityManager.shared.addListener(listener: self)
        self.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ReachabilityManager.shared.removeListener(listener: self)
    }
    
    // MARK: - Network Status
    
    func networkStatusDidChange(status: Reachability.Connection) {
        if (status == .none) {
            showNetworkStatusAlert()
        }
    }
    
    func showNetworkStatusAlert() {
        let alert = UIAlertController(title: "Connectivity Issue", message: "Check your connection for updated results", preferredStyle: .alert)
        alert.view.tintColor = Style.purple
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Methods to fetch data
    
    func reloadData() {
        dataManager.getPopularGames {
            self.collectionView?.reloadSections(IndexSet(integer: 0))
        } 
    }
    
    func setupPullToRefresh() {
        if #available(iOS 10.0, *) {
            self.collectionView?.refreshControl = refreshControl
        } else {
            self.collectionView?.addSubview(refreshControl)
        }
        self.collectionView?.alwaysBounceVertical = true
        self.refreshControl.tintColor = UIColor.white
        self.refreshControl.attributedTitle = NSAttributedString(string: "Fetching Popular Games", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.refreshControl.addTarget(self, action: #selector(refreshPopularGames(_:)), for: .valueChanged)
    }
    
    @objc
    private func refreshPopularGames(_ sender: Any) {
        if ReachabilityManager.shared.reachability.connection == .none {
            self.showNetworkStatusAlert()
        } else {
            self.reloadData()
        }
        self.refreshControl.endRefreshing()
    }
    
    // MARK : - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Responsive cells
        var width = UIScreen.main.bounds.width/2-15
        if Device.thisDevice == .iPad {
            width = UIScreen.main.bounds.width/3-14
        }
        let height = 1.47*width
        
        return CGSize(width: width, height: height)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailGameTableViewController, let row = self.collectionView?.indexPathsForSelectedItems?.first?.row {
            destination.dataManager = self.dataManager
            destination.detailedGame = self.dataManager.games[row]
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionView?.backgroundView?.alpha = 0
        //Connection failed and none data was fetched
        if self.dataManager.games.count == 0 && ReachabilityManager.shared.reachability.connection == .none {
            self.collectionView?.backgroundView?.alpha = 1
            do {
                let backgroundView = try FailedToFetchDataViewController.instanceView(with: "Check your internet connection!")
                DispatchQueue.main.async {
                    self.collectionView?.backgroundView = backgroundView
                }
            } catch {
                print("Error showing the failed to fetch viewController")
            }
        }
        return self.dataManager.games.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameCollectionViewCell else { return UICollectionViewCell() }
        cell.game = dataManager.games[indexPath.row]
        cell.setUpBorder()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailGame", sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //JSON Pagination
        if indexPath.row + 3 > self.dataManager.games.count {
            self.dataManager.loadMoreGames(offset: self.dataManager.games.count+1, completed: {
                self.collectionView?.reloadSections(IndexSet(integer: 0))
            })
        }
    }
}
