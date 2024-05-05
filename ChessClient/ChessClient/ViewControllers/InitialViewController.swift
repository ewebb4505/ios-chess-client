//
//  InitialViewController.swift
//  ChessClient
//
//  Created by Evan Webb on 5/4/24.
//

import Foundation
import UIKit

class InitialViewController: UIViewController {
    var player: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        let button1 = UIButton()
        button1.backgroundColor = .blue
        button1.setTitle("Create User", for: .normal)
        button1.sizeToFit()
        button1.addTarget(self, action: #selector(buttonAction1), for: .touchUpInside)
        
        let button2 = UIButton()
        button2.backgroundColor = .green
        button2.setTitle("Test Chess Game", for: .normal)
        button2.sizeToFit()
        button2.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        view.backgroundColor = .white
    }
    
    @objc func buttonAction1(sender: UIButton!) {
        Task {
            do {
                let url = URL(string: "http://localhost:8080/user")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let (data, _) = try await URLSession.shared.data(for: request)
                if let newPlayer = try? JSONDecoder().decode(Player.self, from: data) {
                    player = newPlayer
                    navigationController?.pushViewController(PlayerPoolViewController(player: player), animated: true)
                } else {
                    print("Invalid Response")
                }
            } catch {
                print("Failed to Send POST Request \(error)")
            }
        }
    }
    
    @objc func buttonAction2(sender: UIButton!) {
        navigationController?.pushViewController(ChessGameViewController(), animated: true)
    }
}
