//
//  ViewController.swift
//  WhoTube
//
//  Created by Raymondting on 2023/8/28.
//

import UIKit
import SwiftyJSON
import RxSwift
import CryptoSwift

class PlayListViewController: BaseViewController {
    
    let viewModel = PlayItemListViewModel()
    
    lazy var playListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 250
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PlayListItemCell.self, forCellReuseIdentifier: PlayListItemCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setAsWhite()
        let searchImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItem = searchButton
        
        let logoImage = UIImage(named: "Logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.30, height: 30)
        logoImageView.contentMode = .scaleAspectFit
        let logoContainer = UIView(frame: logoImageView.bounds)
        logoContainer.addSubview(logoImageView)
        let logoItem = UIBarButtonItem(customView: logoContainer)
        navigationItem.leftBarButtonItem = logoItem
        
        // get init data
        viewModel.getInitData()
    }

    @objc func searchTapped() {
        let search = SearchVideoViewController(playItemList: viewModel.playItemList.value)
        self.navigationController?.pushViewController(search, animated: true)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        view.addSubview(playListTableView)
        playListTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottom)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.playItemList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.playListTableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.playItemList.map { $0.isEmpty }
        .observe(on: MainScheduler.instance)
        .bind(to: playListTableView.rx.noDataLabelVisible)
        .disposed(by: disposeBag)
        
        viewModel.title.bind(to: self.rx.title).disposed(by: disposeBag)
        
        playListTableView.reachedBottom
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchNextPage()
            }).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe(onNext: {[weak self] args in
            let (title, msg) = args
            self?.presentAlert(title: title, message: msg, callback: nil)
        }).disposed(by: disposeBag)
    }
}

extension PlayListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playItemList.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayListItemCell.identifier)
            as? PlayListItemCell ?? PlayListItemCell()
        
        cell.setData(viewModel.playItemList.value[indexPath.row])
        
        return cell
    }
}

extension PlayListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.playItemList.value.count else { return }
        self.navigationController?.pushViewController(PlayVideoViewController(viewModel.playItemList.value[indexPath.row]), animated: true)
    }
}

