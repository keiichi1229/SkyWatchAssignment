//
//  CommentDialogViewController.swift
//  WhoTube
//
//  Created by Raymondting on 2023/9/5.
//

import UIKit
import SwiftyJSON
import RxSwift

class CommentDialogViewController: BaseViewController {
    
    let viewModel = CommentDialogViewModel()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 22
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .dinPro(18)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var commentList: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        return tableView
    }()

    var supportPanGestureToDragDown = true
    var panDropCloseCallback: (() -> Void)?
    let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    var initialTouchPoint: CGPoint?
    var dragDownLimit: CGFloat = 0
    let screenHeight = UIScreen.main.bounds.height
    
    func close(_ callback: (() -> Void)? = nil) {
        let height = bottomView.frame.height
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor.clear
            self.bottomView.frame.origin.y += height
        }) { result in
            self.dismiss(animated: false, completion: {
                callback?()
            })
        }
    }
    
    @objc func tapToClose() {
        close(panDropCloseCallback)
    }
    
    func dropDownToClose() {
        close(panDropCloseCallback)
    }

    override func bind() {
        super.bind()
        
        viewModel.commentItems.observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.commentList.reloadData()
        }).disposed(by: disposeBag)
        
        commentList.reachedBottom
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchNextComments()
            }).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe(onNext: {[weak self] args in
            let (title, msg) = args
            self?.presentAlert(title: title, message: msg, callback: nil)
        }).disposed(by: disposeBag)
        
        viewModel.commentItems.map { $0.isEmpty }
        .observe(on: MainScheduler.instance)
        .bind(to: commentList.rx.noDataLabelVisible)
        .disposed(by: disposeBag)
    }
    
    override func initSubviews() {
        super.initSubviews()
        self.view.backgroundColor = .white
        
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }
        
        bottomView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        bottomView.addSubview(commentList)
        commentList.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(350)
            make.bottom.equalToSuperview().offset(-bottom)
        }
    }
  
    init(_ videoId: String,
         title: String? = nil,
         supportPan: Bool = true,
         callback: (() -> Void)? = nil,
         negativeCallback: (() -> Void)? = nil,
         panDropCloseCallback: (() -> Void)? = nil
    ) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        supportPanGestureToDragDown = supportPan
        headerLabel.text = "Comments"
        self.panDropCloseCallback = panDropCloseCallback
        
        viewModel.getInitComments(videoId: videoId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if supportPanGestureToDragDown {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                                     action: #selector(panGestureRecognizerHandler))
            bottomView.addGestureRecognizer(panGestureRecognizer)
            
            view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                             action: #selector(tapToClose)))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = bottomView.frame.height
        dragDownLimit = height / 3
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.bottomView.frame.origin.y -= height
        })
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: bottomView)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if initialTouchPoint == nil {
                initialTouchPoint = touchPoint
            }
            
            let height = bottomView.frame.height
            
            if let point = initialTouchPoint {
                if bottomView.frame.origin.y + (touchPoint.y - point.y) >= (screenHeight - height) &&
                    bottomView.frame.origin.y + (touchPoint.y - point.y) <= screenHeight {
                    bottomView.frame.origin.y += touchPoint.y - point.y
                }
            }
        case .ended, .cancelled:
            if bottomView.frame.origin.y > screenHeight - dragDownLimit * 2 {
                dropDownToClose()
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                    self.bottomView.frame.origin.y = self.screenHeight - self.bottomView.frame.height
                })
            }
            initialTouchPoint = nil
        default:
            initialTouchPoint = nil
        }
    }
}

extension CommentDialogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.commentItems.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier) as? CommentCell ?? CommentCell()
        
        let item = viewModel.commentItems.value[indexPath.row]
        cell.commentLabel.text = item.snippet.topLevelComment.snippet.textDisplay
        cell.timeLabel.text = item.snippet.topLevelComment.snippet.updatedAt.yyyyMMddhhmmss
        
        return cell
    }
}

extension CommentDialogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
