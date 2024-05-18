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
        button1.setTitle("Play With Someone!", for: .normal)
        button1.sizeToFit()
        button1.addTarget(self, action: #selector(buttonAction1), for: .touchUpInside)
        
        let button2 = UIButton()
        button2.backgroundColor = .green
        button2.setTitle("Test The Board", for: .normal)
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
        navigationController?.pushViewController(LoadingGameViewController(), animated: true)
    }
    
    @objc func buttonAction2(sender: UIButton!) {
        navigationController?.pushViewController(ChessGameViewController(), animated: true)
    }
}
