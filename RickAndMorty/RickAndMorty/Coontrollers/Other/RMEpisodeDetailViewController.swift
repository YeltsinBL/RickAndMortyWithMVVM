//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 13/03/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {

    
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episodio"
        view.backgroundColor = .systemGreen
    }
    

}
