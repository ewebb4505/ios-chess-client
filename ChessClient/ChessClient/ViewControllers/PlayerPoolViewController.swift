//
//  PlayerPoolViewController.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation
import UIKit

class PlayerPoolViewController: UIViewController {
    private let viewModel: PlayerPoolViewModel
    
    private let availablePlayersTableView = UITableView()
    private var safeArea: UILayoutGuide!
    
    init(player: Player) {
        self.viewModel = PlayerPoolViewModel(player: player)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        setAvailablePlayersTableView()
    }
    
    func setAvailablePlayersTableView() {
        view.addSubview(availablePlayersTableView)
        availablePlayersTableView.translatesAutoresizingMaskIntoConstraints = false
        availablePlayersTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        availablePlayersTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        availablePlayersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        availablePlayersTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
