//
//  PlayVideoViewController.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import UIKit
import youtube_ios_player_helper

class PlayVideoViewController: BaseViewController {
    
    var viewModel: PlayVideoViewModel
    
    let titleView: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsWhenVerticallyCompact = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.titleView = titleView
    }
    
    init(_ playItem: PlayItem) {
        viewModel = PlayVideoViewModel(withPlayVideoItem: playItem)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initSubviews() {
        
    }
    
    override func bind() {
        viewModel.title.bind(to: titleView.rx.text).disposed(by: disposeBag)
    }
}
