//
//  PlayVideoViewController.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import UIKit
import youtube_ios_player_helper
import Lottie
import ActiveLabel

class PlayVideoViewController: BaseViewController {
    
    var viewModel: PlayVideoViewModel
    
    let titleView: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var playerView: YTPlayerView = {
        let player = YTPlayerView()
        player.delegate = self
        return player
    }()
    
    lazy var playerMask: AnimationView = {
        let view = AnimationView(filePath: Bundle.main.path(forResource: "Loading", ofType: "json") ?? "")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = false
        view.backgroundColor = .black
        return view
    }()
    
    let infoView = InfoView()
    
    let videoInfoLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.font = .dinProMedium(14)
        label.backgroundColor = .lightGray242
        label.enabledTypes = [.url]
        label.handleURLTap { url in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        return label
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Comments", for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .black
        
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsWhenVerticallyCompact = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.titleView = titleView
        
        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.handleOrientationChange()
            }).disposed(by: disposeBag)
    }

    func handleOrientationChange() {
        let orientation: UIInterfaceOrientation
        if #available(iOS 13.0, *) {
            orientation = self.view.window?.windowScene?.interfaceOrientation ?? .unknown
        } else {
            orientation = UIApplication.shared.statusBarOrientation
        }
        
        // Reset all views
        playerView.removeFromSuperview()
        infoView.removeFromSuperview()
        videoInfoLabel.removeFromSuperview()
        commentButton.removeFromSuperview()
        
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            self.view.addSubview(playerView)
            playerView.snp.remakeConstraints { make in
                make.edges.equalTo(self.view)
            }
        } else {
            self.contentView.addSubview(playerView)
            self.contentView.addSubview(infoView)
            self.contentView.addSubview(videoInfoLabel)
            self.contentView.addSubview(commentButton)
            
            playerView.snp.remakeConstraints { make in
                make.top.equalTo(self.contentView).offset(5)
                make.leading.trailing.equalTo(self.contentView).inset(5)
                make.height.equalTo(360)
            }
            
            infoView.snp.remakeConstraints { make in
                make.top.equalTo(playerView.snp.bottom).offset(5)
                make.leading.trailing.equalTo(playerView)
            }
            
            videoInfoLabel.snp.remakeConstraints { make in
                make.top.equalTo(infoView.snp.bottom).offset(5)
                make.leading.trailing.equalTo(infoView)
            }
            
            commentButton.snp.remakeConstraints { make in
                make.top.equalTo(videoInfoLabel.snp.bottom).offset(5)
                make.leading.trailing.equalTo(videoInfoLabel)
                make.height.equalTo(50)
                make.bottom.equalToSuperview()
            }
        }
        
        self.view.layoutIfNeeded()
    }

    init(_ playItem: PlayItem) {
        viewModel = PlayVideoViewModel(withPlayVideoItem: playItem)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initSubviews() {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(playerView)
        contentView.addSubview(playerMask)
        contentView.addSubview(infoView)
        contentView.addSubview(videoInfoLabel)
        contentView.addSubview(commentButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
            make.bottom.equalToSuperview().offset(-bottom - 10) // take some gap
        }
    
        playerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(360)
        }
        
        playerMask.snp.makeConstraints { make in
            make.edges.equalTo(playerView)
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(playerView)
        }
        
        videoInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(5)
            make.leading.trailing.equalTo(infoView)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(videoInfoLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(videoInfoLabel)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-bottom)
        }
    }
    
    override func bind() {
        viewModel.title.bind(to: titleView.rx.text).disposed(by: disposeBag)
        
        viewModel.playVideoItem.subscribe(onNext: { [weak self] item in
            guard let item = item, let self = self else { return }
            self.playerMask.play(completion: nil)
            self.playerView.load(withVideoId: item.snippet.resourceId.videoId,
                                 playerVars: self.viewModel.playerVars)
            self.infoView.setData(ownerImageUrl: item.ownerThumbnails?.medium.url ?? "",
                                  videoTitle: item.snippet.title,
                                  ownerTitle: item.snippet.videoOwnerChannelTitle,
                                  uploadDateTime: item.snippet.publishedAt.yyyyMMddhhmmss)
            self.viewModel.getVideoInfo(videoId: item.snippet.resourceId.videoId)
        }).disposed(by: disposeBag)
        
        viewModel.videoDescription.bind(to: videoInfoLabel.rx.text).disposed(by: disposeBag)
        
        commentButton.rx
            .tap
            .subscribe({[weak self] _ in
                guard let self = self, let item = self.viewModel.playVideoItem.value else { return }
                let commentView = CommentDialogViewController(item.snippet.resourceId.videoId)
                self.present(commentView, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe(onNext: {[weak self] args in
            let (title, msg) = args
            self?.presentAlert(title: title, message: msg, callback: nil)
        }).disposed(by: disposeBag)
    }
}

extension PlayVideoViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerMask.removeFromSuperview()
    }
}
