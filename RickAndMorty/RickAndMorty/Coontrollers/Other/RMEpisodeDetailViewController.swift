//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 13/03/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {

    
    private let episodeDetailViewViewModel: RMEpisodeDetailViewViewModel
    
    
    //MARK: - Init
    
    init(url: URL?) {
        self.episodeDetailViewViewModel = .init(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Cycle Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episodio"
        view.backgroundColor = .systemGreen
    }
    
    
    //MARK: - Func

    
}
